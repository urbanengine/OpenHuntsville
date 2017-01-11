# Opt-in/out Additions
1. Update the `people` `:edit` route such that if a user has chosen to opt-out, we’ll require them to opt-in before editing their profile. Basically I’m envisioning showing a page that says “You have opted out. Please opt-in to OpenHSV Version 2.0 before editing your profile information. This will allow your profile to be public again.”
2. Add logic that pulls the list of `people` and filter it so that its only the list of `people` that have opted in.
3. ~~Fix the use of cookies[:people] using the original logic with `/logout` setting the cookies[:people] = 0. Should be sufficient to reset cookies.~~
4. Figure out bug in `/login`. Not sure why the change was required.

# Bugs
1. ~~Error checking on events to make sure that in the edit page a user has the correct credentials to have edit rights. I think currently someone could edit any event by manipulating the url~~
2. ~~Don't show past events~~
3. ~~Make it so that when an Admin creates an event or a group, it is automatically approved~~
4. ~~Add admin interface for Groups. Should be able to add people as group admins~~
5. ~~If an event start_datetime or venue is updated, but has already been approved, it should be set back to unapproved~~
6. ~~Remove all the search boxes from the pages where the search box doesn't work. Basically all the events/group pages.~~
7. Heroku DateTime parsing is off for some reason. Maybe something about where the Heroku server is? Do we have some sort of hardcoded timezone that is screwing up our logic? For example: events.rb ln. 135; Basically we need to have all backend logic done in UTC, but, anytime we show a DateTime to a user, we should use localtime.
8. ~~**Need prior to Wednesday:** Add logic to Event creation/editing to make sure the user inputs a Name, selects a Group and Venue!~~
9. ~~I now realized why `logout` simply changed the `cookies[:people]` to 0. Should revert the change I made and return to the old workflow for cookie management. Especially with Kyle's recent change for opt-in~~

# Enhancements
1. ~~Group workflows for group creation~~
2. Email all admins when their event has been approved
3. ~~Refine the event approval process. Make the dashboard page the same as the manage page but different for admins~~
4. Custom_url for groups, just like people
5. Need to add an `/events/past` route to show past events
6. Implement a search box such that you can search a particular category. Would be nice to search for People, or Events, or Groups, or all of the above. Would be nice to have a dropdown with checkboxes on what categories to search
7. `/events/` and `/events/:events_id/` routes should look / operate like `/people/` and `/people/:people_id/`
8. Add mechanism to have users join groups. Group admins should be able to approve users if the group is set up to require approved on join request

# Potential Enhancements
1. Fix the breadcrumbs for events so instead of showing Home / People / Tyler Hughes / Events it says Home / Events
2. Clean up `dashboard` route: move it to `people/manage`, and make it look like the `events/manage`
3. Make error pages actually represent the reason you're receiving the error
4. Add ability to request assets (i.e. TV/Projector/Whiteboard etc.)
5. Look into using webshim for Safari form validation


# Event Flow Notes
1. We need some type of question asking how long the event will be. (i.e. Designer's Corner is 1hr and 4 Hours To Product is 4 hours)
2. Once we set up the form so that various questions are exposed one question at a time we should add a question asking what resources are needed.
    - This question is only neccesary if this is a CoWorking Night event. Other events such as 3210 or Big Spring Wine Crush will not need this.
3. Would be good if we could ask if this is the first time the event is being held (CoWorking Night only)
    - This is so that I will know to reach out to them (in case an event organizer points someone to the form instead of talking to me)
