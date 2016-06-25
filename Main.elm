import Html exposing (..)
import Html.App as App exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

main =
    App.program
        { init = init
        , update = update
        , subscriptions = subs
        , view = view
        }

type alias Model =
    { master1 : String
    , master2 : String
    , encrypt_input : String
    , encrypt_output : String
    , decrypt_input: String
    , decrypt_output: String
    }
