import { application } from "./application"
import SearchController from "./search_controller"
import PostActionsController from "./post_actions_controller"

application.register("search", SearchController)
application.register("post-actions", PostActionsController)
