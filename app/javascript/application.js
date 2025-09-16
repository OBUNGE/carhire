import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"

export const application = Application.start()
window.application = application // allows console inspection

import "./controllers"

import "./car_show"

import "./cars_carousel"


