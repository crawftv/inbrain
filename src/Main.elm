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
    | Success HNJob



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
        , url = "https://hacker-news.firebaseio.com/v0/item/192327.json"
        , expect = Http.expectJson GotJson hnDecoder
        , timeout = Nothing
        , tracker = Nothing
        }
    )


type Msg
    = GotJson (Result Http.Error HNJob)


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

        Success hnjob ->
            v hnjob


type alias HNJob =
    { by : String
    , id : Int
    , score : Int
    , text : String
    , title : String
    , time : Int
    , url : String
    }


hnDecoder : Decoder HNJob
hnDecoder =
    Decode.succeed HNJob
        |> required "by" string
        |> required "id" int
        |> required "score" int
        |> required "text" string
        |> required "title" string
        |> required "time" int
        |> required "url" string


hnresult : String -> Result Decode.Error HNJob
hnresult =
    Decode.decodeString
        hnDecoder


v hnjob =
    Element.layout [] (vr hnjob)


vr : HNJob -> Element msg
vr hnjob =
    Element.wrappedRow [ width fill, Font.size 14 ]
        [ Element.el [ spacing 5, Border.color (rgb255 0 0 0), Border.solid, Border.width 1 ] (text hnjob.title)
        , Element.el [ Border.rounded 3, Border.glow (rgb255 0 0 0) 0.5, Border.color (rgb255 0 0 0), Border.solid, Border.width 1 ] (cardLink hnjob.title)
        , Element.el [ Border.color (rgb255 240 140 255), Border.solid ] (text hnjob.title)
        ]


cardLink : String -> Element msg
cardLink title =
    Element.newTabLink []
        { url = "https://crawfordc.com"
        , label = card title
        }


card : String -> Element msg
card title =
    Element.column
        [ Border.color (rgb255 150 150 150), spacing 5, padding 5 ]
        [ Element.image
            [ width (fill |> maximum 300 |> minimum 150)
            , height (fill |> maximum 300 |> minimum 150)
            ]
            { description = "ad", src = "https://cdn4.buysellads.net/uu/1/54614/1569954897-microsoft-azure-logo-260x200.png" }
        , Element.paragraph [] [ Element.text title ]
        ]
