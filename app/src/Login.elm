module Login exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Html.App as App exposing (..)


--------------------------------------------------------------------------------
-- Model


type alias Model =
    { username : String
    , password : String
    }


initModel : Model
initModel =
    { username = ""
    , password = ""
    }



--------------------------------------------------------------------------------
-- Update


type Msg
    = UsernameInput String
    | PasswordInput String


update : Msg -> Model -> Model
update msg model =
    case msg of
        UsernameInput username ->
            { model | username = username }

        PasswordInput password ->
            { model | password = password }



--------------------------------------------------------------------------------
-- View


view : Model -> Html Msg
view model =
    div []
        [ h3 [] [ text "Login Page... So far" ]
        , Html.form []
            [ input
                [ type' "text"
                , onInput UsernameInput
                , placeholder "username"
                ]
                []
            , input
                [ type' "password"
                , onInput PasswordInput
                , placeholder "password"
                ]
                []
            ]
        , hr [] []
        , h4 [] [ text "Login Model:" ]
        , p [] [ text <| toString model ]
        ]



--------------------------------------------------------------------------------
--Main


main : Program Never
main =
    App.beginnerProgram
        { model = initModel
        , view = view
        , update = update
        }
