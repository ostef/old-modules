## 05/07/2022

An important thing to note is that, in general, the user will interact with only one UI
widget at a time, except for text input fields. This means that we only have to store the
persistent state needed for an interaction once, instead of having it for each control.
This is great because that means we don't have to store anything for each control, and
we can instead use a unique Id to differentiate widgets. This is what Dear ImGui does.

About persistent widget state: it seems the only reason to want a mechanism to store
persistent state for each widget is for transition animations, because for actual interaction,
the user will likely want to have access to this data, which means they can store it themselves,
and for actual animation like rotating an element and stuff, most of the time you can do that by just using
the elapsed time of the program. After trying to make a metaprogram plugin that inserts
storage structures for each widget type at the right scopes, it seems that it is not possible
to do that in a simple way. Persistent state will have to be a user side thing for now.

## 04/07/2022

# Persistent widget state
I would like to have something very simple like Dear ImGUI, but I think with this
library, the user always has to store persistent widget state themself, which is a problem
if we want to do animation.

In Dear ImGui, widgets are not actually stored anywhere, rather they are just something
that exist because they get drawn on the screen, and the only thing you have are Ids and
the state that is returned by the widget function. I would like to have that as a basis,
for simple cases where you don't actually need to store any persistent widget state,
and have a way to store data for each widget.

What we'll do is have a structure that has a hash map of id => widget data for each
widget type, and that structure is generated at compile time by looking at each of
the structures that have a @Widget note on them. We'll also have routines that
do interaction without needing any persistent data, like `button_behaviour`, which
is also a function that is in Dear ImGui as well as in Nuklear.

# Layout
I don't really want to do any complicated layout mechanism, because I believe it is
not bringing any benefit since the user can calculate the sizes of things dynamically
very easily, because of the 'immediate' nature of the design, and they will have to
declare the way the control is sized and positioned anyway with a complex auto layout
system.

What we do need though is to be able to express coordinates relative to something arbitrary,
like a window, a dropdown menu rect, a scrollable region's top left corner etc.

# Keyboard navigation
To do keyboard navigation, we'll probably have something that follows the flow of widgets
that are declared by the caller, because it does not require anything complex. I am still
unsure as to how we'll do that though.
