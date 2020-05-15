module Main exposing (..)

import Browser
import Element exposing (Element, el, fill, height, maximum, minimum, padding, rgb255, row, shrink, spaceEvenly, spacing, text, width)
import Element.Border as Border
import Element.Font as Font
import Html
import Http
import Json.Decode as Decode exposing (Decoder, field, int, list, map2, string)
import Json.Decode.Pipeline exposing (required)


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type Model
    = Failure
    | Loading
    | Success Story



-- cors : String -> String -> Http.Header
--cors =
--  Http.header "Access-Control-Request-Method" "GET"


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading
    , Http.request
        { body = Http.emptyBody
        , method = "GET"
        , headers = []
        , url = "http://laptop-3qkgiicm:8080/"
        , expect = Http.expectJson GotJson storyDecoder
        , timeout = Nothing
        , tracker = Nothing
        }
    )


type Msg
    = GotJson (Result Http.Error Story)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotJson result ->
            case result of
                Ok fullText ->
                    ( Success fullText, Cmd.none )

                Err _ ->
                    ( Failure, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html.Html Msg
view model =
    case model of
        Failure ->
            Html.text "error"

        Loading ->
            Html.text "Loading"

        Success story ->
            v story


type alias Story =
    { author : String
    , title : String
    , subtitle : String
    , domain : String
    }


storyDecoder : Decoder Story
storyDecoder =
    Decode.succeed Story
        |> required "author" string
        |> required "title" string
        |> required "subtitle" string
        |> required "domain" string


storyResult : String -> Result Decode.Error Story
storyResult =
    Decode.decodeString
        storyDecoder


v story =
    Element.layout [] (vr story)


vr : Story -> Element msg
vr story =
    Element.wrappedRow [ width fill, Font.size 14 ]
        [ Element.el [ Border.rounded 3, Border.glow (rgb255 0 0 0) 0.5, Border.color (rgb255 0 0 0), Border.solid, Border.width 1 ] (cardLink story)
        , Element.el [ Border.rounded 3, Border.glow (rgb255 0 0 0) 0.5, Border.color (rgb255 0 0 0), Border.solid, Border.width 1 ] (cardLink story)
        , Element.el [ Border.rounded 3, Border.glow (rgb255 0 0 0) 0.5, Border.color (rgb255 0 0 0), Border.solid, Border.width 1 ] (cardLink story)
        ]


cardLink : Story -> Element msg
cardLink story =
    Element.newTabLink []
        { url = "https://crawfordc.com"
        , label = card story
        }


card : Story -> Element msg
card story =
    Element.column
        [ Border.color (rgb255 150 150 150), spacing 5, padding 5 ]
        [ Element.el [Font.size 18, Font.bold] (Element.text story.title)
        , Element.el [Font.italic] (Element.paragraph [] [Element.text story.subtitle])
        , Element.el [] (Element.text (String.concat[ "by: " ,story.author]) )
        ]
