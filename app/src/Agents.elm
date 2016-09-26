-- Module & Imports


module Agents exposing (..)

import Html.Attributes exposing (..)
import Html exposing (..)
import Html.App as App exposing (..)
import Html.Events exposing (..)
import Http exposing (..)
import Task exposing (Task)
import Json.Decode exposing (int, string, float, Decoder)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)


--------------------------------------------------------------------------------
-- Model


type alias Model =
    { helloWorld : String
    , pageName : String
    , message : String
    , agents : List AgentInfo
    }


type Msg
    = NoOp
    | NewAgent
    | GetAgents
    | ErrorOccurred String
    | AgentsFetched (List AgentInfo)


type alias AgentInfo =
    { id : Int
    , username : String
    , password : String
    , firstname : String
    , lastname : String
    , displayname : String
    , title : String
    , phone : String
    , email : String
    , bio : String
    , created : String
    , pic : String
    }


type Error
    = Timeout
    | NetworkError
    | UnexpectedPayload String
    | BadResponse Int String


initModel =
    let
        model =
            { helloWorld = "Hello World!"
            , pageName = "Profile"
            , message = " Click to load Profile"
            , agents = []
            }
    in
        model ! [ getAgents ]



--------------------------------------------------------------------------------
-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        NewAgent ->
            model ! []

        GetAgents ->
            { model | message = "Loading your Profile" } ! [ getAgents ]

        ErrorOccurred errorMessage ->
            { model | message = "An error occurred: " ++ errorMessage } ! []

        AgentsFetched agents ->
            { model | agents = agents, message = "Retrieved Profile" } ! []



--------------------------------------------------------------------------------
-- View


view : Model -> Html Msg
view model =
    let
        showAgent agent =
            div
                [ class "panel panel-default agent-card" ]
                [ div
                    [ class "panel-heading" ]
                    [ div [] [ img [ class "profile-pic", src agent.pic ] [] ]
                    , div [ class "profile-title" ]
                        [ h3
                            [ class "panel-title" ]
                            [ text <| agent.firstname ++ " " ++ agent.lastname ]
                        , h6 []
                            [ text <| agent.title ]
                        ]
                    ]
                , div
                    [ class "panel-body" ]
                    [ ul [ attribute "style" "list-style: none;" ]
                        [ li []
                            [ text <| "Goes by: " ++ agent.displayname ]
                        , li []
                            [ text <| "Phone: " ++ agent.phone ]
                        , li []
                            [ text <| "Email: " ++ agent.email ]
                        , li []
                            [ text <| agent.bio ]
                        ]
                    ]
                ]
    in
        div []
            [ hr [] []
            , ul [] (List.map showAgent model.agents)
              -- ERROR CHECKING MESSAGE CODE
              -- , p []
              --     [ text "the 'in' is working." ]
              -- , p []
              --     [ text <| (toString model.message) ]
              -- , p []
              --     [ text <| (toString model.agents) ]
            , hr [] []
            ]


formView : Model -> Html Model
formView model =
    div []
        [ p [] [ text model.helloWorld ]
        , p [] [ text model.pageName ]
        , div []
            [ h3 [] [ text "New Agent" ]
            , Html.form []
                [ input
                    [ type' "text"
                      -- , onInput UsernameInput
                    , placeholder "Username"
                    ]
                    []
                , br [] []
                , input
                    [ type' "password"
                      -- , onInput PasswordInput
                    , placeholder "Password"
                    ]
                    []
                , br [] []
                , input
                    [ type' "text"
                      -- , onInput FirstNameInput
                    , placeholder "First Name"
                    ]
                    []
                , br [] []
                , input
                    [ type' "text"
                      -- , onInput LastNameInput
                    , placeholder "Last Name"
                    ]
                    []
                , br [] []
                , input
                    [ type' "text"
                      -- , onInput DisplayNameInput
                    , placeholder "Display Name"
                    ]
                    []
                , br [] []
                , input
                    [ type' "text"
                      -- , onInput TitleInput
                    , placeholder "Title"
                    ]
                    []
                , br [] []
                , input
                    [ type' "text"
                      -- , onInput PhoneInput
                    , placeholder "Phone"
                    ]
                    []
                , br [] []
                , input
                    [ type' "text"
                      -- , onInput EmailInput
                    , placeholder "Last Name"
                    ]
                    []
                , br [] []
                , input
                    [ type' "text"
                      -- , onInput BioInput
                    , placeholder "Bio"
                    ]
                    []
                , br [] []
                , input
                    [ type' "submit" ]
                    [ text "Submit" ]
                ]
            ]
        , hr [] []
        ]



--------------------------------------------------------------------------------
-- Agents


agentInfoDecoder : Json.Decode.Decoder AgentInfo
agentInfoDecoder =
    decode AgentInfo
        |> Json.Decode.Pipeline.required "id" int
        |> Json.Decode.Pipeline.required "username" Json.Decode.string
        |> Json.Decode.Pipeline.required "password" Json.Decode.string
        |> Json.Decode.Pipeline.required "firstname" Json.Decode.string
        |> Json.Decode.Pipeline.required "lastname" Json.Decode.string
        |> Json.Decode.Pipeline.required "displayname" Json.Decode.string
        |> Json.Decode.Pipeline.required "title" Json.Decode.string
        |> Json.Decode.Pipeline.required "phone" Json.Decode.string
        |> Json.Decode.Pipeline.required "email" Json.Decode.string
        |> Json.Decode.Pipeline.required "bio" Json.Decode.string
        |> Json.Decode.Pipeline.required "created" Json.Decode.string
        |> Json.Decode.Pipeline.required "pic" Json.Decode.string


agentInfoListDecoder : Decoder (List AgentInfo)
agentInfoListDecoder =
    Json.Decode.list agentInfoDecoder


getAgents : Cmd Msg
getAgents =
    Http.get agentInfoListDecoder "https://clarkeagency.herokuapp.com/agents"
        --"http://localhost:3000/agents"
        |>
            Task.mapError toString
        |> Task.perform ErrorOccurred AgentsFetched


customGetAgents : Task RawError Response
customGetAgents =
    send defaultSettings
        { verb = "GET"
        , headers =
            [ ( "Accept", "application/json" )
            , ( "Content-Type", "application/json" )
            , ( "Authorization", "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NiwidXNlcm5hbWUiOiJnYWJlIiwiaWF0IjoxNDc0MTQxMTkwfQ.Hpydi6C7Hr0f8aNbZtY3G8ybrjynmjITuZgsqt3MrZs" )
            ]
        , url = "http://localhost:3000/agents"
        , body = empty
        }


type alias Request =
    { verb : String
    , headers : List ( String, String )
    , url : String
    , body : Body
    }



--------------------------------------------------------------------------------
-- Main


main : Program Never
main =
    App.program
        { init = initModel
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
