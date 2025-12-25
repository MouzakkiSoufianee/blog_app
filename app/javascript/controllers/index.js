import { application } from "./application"
import SearchController from "./controllers/search_controller"

application.register("search", SearchController)
