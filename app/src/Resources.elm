-- Module & Imports


module Resources exposing (..)

import Html.Attributes exposing (..)
import Html exposing (..)
import Html.App as App exposing (..)
import Html.Events exposing (..)
import Http exposing (..)
import Task exposing (Task)
import Json.Decode as Json exposing ((:=))


--------------------------------------------------------------------------------
-- Model


type alias Model =
    { helloWorld : String
    , pageName : String
    , message : String
    , resources : List ResourceInfo
    }


type Msg
    = NoOp
    | GetResources
    | ErrorOccurred String
    | ResourcesFetched (List ResourceInfo)


type alias ResourceInfo =
    { id : Int
    , category : String
    , subcategory : String
    , title : String
    , agent_id : Int
    , text : String
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
            , pageName = "Resources"
            , message = "Click to get Resources"
            , resources = []
            }
    in
        model ! [ getResources ]



--------------------------------------------------------------------------------
-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        GetResources ->
            { model | message = "Getting resources" } ! [ getResources ]

        ErrorOccurred errorMessage ->
            { model | message = "An error occurred: " ++ errorMessage } ! []

        ResourcesFetched resources ->
            { model | resources = resources, message = "Retrieved resources" } ! []



--------------------------------------------------------------------------------
-- View


view : Model -> Html Msg
view model =
    let
        showResource resource =
            div
                [ class "panel panel-default" ]
                [ div
                    [ class "panel-heading" ]
                    [ h3
                        [ class "panel-title" ]
                        [ text <| resource.title ]
                    , h5 [] [ text <| resource.category ]
                    , h6 [] [ text <| resource.subcategory ]
                    ]
                , div
                    [ class "panel-body" ]
                    [ div [] [ text <| resource.text ]
                    ]
                ]
    in
        div []
            [ ul [] (List.map showResource model.resources)
            , hr [] []
            ]


formView : Model -> Html Model
formView model =
    div []
        [ p [] [ text model.helloWorld ]
        , p [] [ text model.pageName ]
        , div []
            [ h3 [] [ text "New Resource" ]
            , Html.form []
                [ input
                    [ type' "text"
                      -- , onInput CategoryInput
                    , placeholder "Category"
                    ]
                    []
                , br [] []
                , input
                    [ type' "text"
                      -- , onInput SubCategoryInput
                    , placeholder "Subcategory"
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
                      -- , onInput TextInput
                    , placeholder "Text"
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
-- Resources


resourceInfoDecoder : Json.Decoder ResourceInfo
resourceInfoDecoder =
    Json.object6
        ResourceInfo
        ("id" := Json.int)
        ("category" := Json.string)
        ("subcategory" := Json.string)
        ("title" := Json.string)
        ("agent_id" := Json.int)
        ("text" := Json.string)


resourceInfoListDecoder : Json.Decoder (List ResourceInfo)
resourceInfoListDecoder =
    Json.list resourceInfoDecoder


getResources : Cmd Msg
getResources =
    Http.get resourceInfoListDecoder "https://clarkeagency.herokuapp.com/resources"
        --"http://localhost:3000/resources"
        |>
            Task.mapError toString
        |> Task.perform ErrorOccurred ResourcesFetched


customGetResources : Task RawError Response
customGetResources =
    send defaultSettings
        { verb = "GET"
        , headers =
            [ ( "Accept", "application/json" )
            , ( "Content-Type", "application/json" )
            , ( "Authorization", "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NiwidXNlcm5hbWUiOiJnYWJlIiwiaWF0IjoxNDc0MTQxMTkwfQ.Hpydi6C7Hr0f8aNbZtY3G8ybrjynmjITuZgsqt3MrZs" )
            ]
        , url = "http://localhost:3000/resources"
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
