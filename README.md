# inbrain
## Mission
To make blogging important again. 
I've seen some calls to make bring blogging back. (This article reached number on hacker news recently http://tttthis.com/edit/blog/if-i-could-bring-one-thing-back-to-the-internet-it-would-be-blogs) The inbrain project could be one way to make this happen.

## How does it work?
Currently the plan is to register your articles with a url and text and recieve an embedable content (currently iframe).
Right now we can display random, but relevant articles.
The Roadmap for this projects includes receiving payments and selecting the content you want to display.

## Design Decisions
### Elm
I have been biased towards using elm. But elm's ability to make extremely small bundles is important. Using the elm-ui forces me to not rely on an large library am

### Python
This project makes use of the pydata stack.

### Falcon
python framework. Not as much magic as flask and not as much overhead as django. Can also go very fast.
