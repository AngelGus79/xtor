import Html exposing (..)
import Html.App as App exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String exposing (..)
import List.Extra exposing (getAt)
import Types exposing (..)
import Ports exposing (..)

main =
    App.program
        { init = init
        , update = update
        , subscriptions = subs
        , view = view
        }

init : (Model, Cmd Msg)
init = ( { master1 = ""
         , master2 = ""
         , encrypt_input = ""
         , encrypt_output = ""
         , decrypt_input = ""
         , decrypt_output = ""
         , enc = { text = "", salt = "", iv = "" }
         }
       , Cmd.none
       )

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Master1 str -> { model | master1 = str } ! []
        Master2 str -> { model | master2 = str } ! []
        Encrypt str -> { model | encrypt_input = str } ! []
        Decrypt str -> { model | decrypt_input = str } ! []
        Encryptor -> { model | encrypt_input = "", decrypt_output = "" } ! [ encrypt (model.master1, model.encrypt_input) ]
        Decryptor -> model ! [ decrypt (model.master1, createEncObj model.decrypt_input) ]
        Encrypted enc -> { model | enc = enc, encrypt_output = enc.text } ! []
        Decrypted str -> { model | decrypt_output = str, decrypt_input = "" } ! []

createEncObj : String -> Enc
createEncObj str =
    let
        arr = String.split "/" str
        mText = getAt 0 arr
        mSalt = getAt 1 arr
        mIv = getAt 2 arr
        get m =
            case m of
                Just s -> s
                Nothing -> ""
    in
        { text = get mText, salt = get mSalt, iv = get mIv }



subs : Model -> Sub Msg
subs model =
    Sub.batch
        [ encrypted Encrypted
        , decrypted Decrypted
        ]

view : Model -> Html Msg
view model =
    section [class "hero is-success is-fullheight"]
        [ div [class "hero-body", id "is-top"]
            [ div [class "container"]
                [ h1 [class "title"]
                    [text "xtor - Password Manager"]
                , h2 [class "subtitle"]
                    [ div [class "content"]
                        [ p [] [text "Encrypt / Decrypt in pure client-side JavaScript"]
                        , ul []
                            [ li [] [text "Uses AES-256-CBC with sha256 HMAC"]
                            , li [] [text "Salt generation using PBKDF2 with 32 byte key length"]
                            , li [] [text "Data always stays in the browser (never sent anywhere)"]
                            , li [] [text "Open Source MIT License", a [] [text " Github"]]
                            ]
                        ]
                    ]

                , div [class "tile is-ancestor"]
                    [ div [class "tile is-vertical"]
                        [ div [class "title is-success"]
                            [ div [class "tile is-vertical is-parent"]
                                [ div [class "title is-child box notification is-warning"]
                                    [ p [class "title"] [strong [] [text "Master Password"]]
                                    , masterPasswordFormBox model
                                    ]

                                , div [class "tile is-child box notification is-primary"]
                                    [ p [class "title"] [text "Encryptor"]
                                    , encryptorFormBox model
                                    ]

                                , div [class "tile is-child box notification is-info"]
                                    [ p [class "title"] [text "Decryptor"]
                                    , decryptorFormBox model
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]

masterPasswordFormBox : Model -> Html Msg
masterPasswordFormBox model =
    div [class "columns"]
        [ masterPasswordForm model Master1
        , masterPasswordForm model Master2
        ]

masterPasswordForm : Model -> (String -> Msg) -> Html Msg
masterPasswordForm model masterMsg =
    let
        check_pass = checkMasterPassword model --|> Debug.log "pass"
        fa_icon = if not check_pass then "fa fa-warning" else "fa fa-check"
        danger = if not check_pass then "is-danger" else "is-success"
        err = if not check_pass then "Master passwords mismatch" else "Master passwords OK"
    in
    div [class "column"]
        [ p [class <| "control has-icon has-icon-right"]
            [ input [class <| "input " ++ danger, type' "password", placeholder "Master Password", onInput masterMsg] []
            , i [class fa_icon] []
            , span [class <| "help " ++ danger] [strong [class "subtitle is-6"] [text err]]
            ]
        ]

checkMasterPassword : Model -> Bool
checkMasterPassword model =
    model.master1 == model.master2 && String.length model.master1 > 0

encryptorFormBox : Model -> Html Msg
encryptorFormBox model =
    let
        input_disabled = not <| checkMasterPassword model
        button_disabled = input_disabled || String.length model.encrypt_input <= 0
        val = if String.length model.encrypt_input > 0 then model.encrypt_input else ""
        enc_txt = encryptedText model
        msg_header = if String.length enc_txt > 0 then "Encrypted Text" else ""
        msg_body = if String.length enc_txt > 0 then "message-body" else ""
    in
    div []
        [ p [class "control"]
            [ input [class "input", type' "text", placeholder "Enter Text to Encrypt", value val, disabled input_disabled, onInput Encrypt] []
            , button [class "button is-success", onClick Encryptor, disabled button_disabled] [text "Encrypt"]
            ]
        , article [class "message is-primary"]
            [ div [class "message-header"]
                [ p [class "subtitle is-primary"] [text msg_header] ]
            , div [class msg_body] [text enc_txt]
            ]
        ]

encryptedText : Model -> String
encryptedText model =
    if String.length model.enc.text > 0 && String.length model.enc.salt > 0 && String.length model.enc.iv > 0 then
        model.enc.text ++ "/" ++ model.enc.salt ++ "/" ++ model.enc.iv
    else
        ""

decryptorFormBox : Model -> Html Msg
decryptorFormBox model =
    let
        input_disabled = not <| checkMasterPassword model
        button_disabled = input_disabled || String.length model.decrypt_input <= 0
        val = if String.length model.decrypt_input > 0 then model.decrypt_input else ""
        dec_txt = if String.length model.decrypt_output > 0 then model.decrypt_output else ""
        msg_header = if String.length dec_txt > 0 then "Decrypted Text" else ""
        msg_body = if String.length dec_txt > 0 then "message-body" else ""
    in
    div []
        [ p [class "control"]
            [ input [class "input", type' "text", placeholder "Enter Text to Decrypt", value val, disabled input_disabled, onInput Decrypt] []
            , button [class "button is-success", onClick Decryptor, disabled button_disabled] [text "Decrypt"]
            ]
        , article [class "message is-info"]
            [ div [class "message-header"]
                [ p [class "subtitle is-info"] [text msg_header] ]
            , div [class msg_body] [text dec_txt]
            ]
        ]
