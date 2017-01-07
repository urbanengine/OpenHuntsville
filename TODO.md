# Bugs
1. ~~Error checking on events to make sure that in the edit page a user has the correct credentials to have edit rights. I think currently someone could edit any event by manipulating the url~~
2. ~~Don't show past events~~
3. ~~Make it so that when an Admin creates an event or a group, it is automatically approved~~
4. Add admin interface for Groups. Should be able to add people as group admins
5. ~~If an event start_datetime or venue is updated, but has already been approved, it should be set back to unapproved~~
6. ~~Remove all the search boxes from the pages where the search box doesn't work. Basically all the events/group pages.~~
7. Heroku DateTime parsing is off for some reason. Maybe something about where the Heroku server is? Do we have some sort of hardcoded timezone that is screwing up our logic? For example: events.rb ln. 135; Basically we need to have all backend logic done in UTC, but, anytime we show a DateTime to a user, we should use localtime.
8. ~~**Need prior to Wednesday:** Add logic to Event creation/editing to make sure the user inputs a Name, selects a Group and Venue!~~

# Enhancements
1. ~~Group workflows for group creation~~
2. Email all admins when their event has been approved
3. ~~Refine the event approval process. Make the dashboard page the same as the manage page but different for admins~~
4. Custom_url for groups, just like people
5. Need to add an /events/past route to show past events
6. Implement a search box such that you can search a particular category. Would be nice to search for People, or Events, or Groups, or all of the above. Would be nice to have a dropdown with checkboxes on what categories to search
7. `/events/` and `/events/:events_id/` routes should look / operate like `/people/` and `/people/:people_id/`
8. Add mechanism to have users join groups. Group admins should be able to approve users if the group is set up to require approved on join request

# Potential Enhancements
1. Fix the breadcrumbs for events so instead of showing Home / People / Tyler Hughes / Events it says Home / Events
2. Clean up `dashboard` route: move it to `people/manage`, and make it look like the `events/manage`
3. Make error pages actually represent the reason you're receiving the error
