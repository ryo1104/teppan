require("@rails/ujs").start()
require('jquery')
// require('materialize')
// require('trix')

import './sidenav'
import './stars'

// CSS
import '../stylesheets/style.scss'

// images
const images = require.context('../images', true)
const imagePath = (name) => images(name, true)

// necessary for js.erb files
import $ from 'jquery';
global.$ = jQuery;