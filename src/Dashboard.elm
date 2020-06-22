port module Dashboard exposing (main)

import Browser
import Element
import Element.Region as Region


type Model
     = Loading
    | ProfileLoaded Profile


type alias Profile =
    { name : String
    }


type Msg
    = RecieveProfile String


port messageReceiver : (String -> msg) -> Sub msg

setProfileName : String -> Profile
setProfileName newName =
    { name = newName }

init : () -> ( Model, Cmd Msg )
init flags =
    (Loading
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions _ =
    messageReceiver RecieveProfile


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RecieveProfile newProfile ->
            ( ProfileLoaded (Profile newProfile)
            , Cmd.none
            )



view : Model -> Browser.Document Msg
view model =
    { title = "Dashboard"
    , body = [ Element.layout [] (view_body model)]
    }

view_body model =
   Element.el [Region.mainContent] (Element.text (Debug.toString model))


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
