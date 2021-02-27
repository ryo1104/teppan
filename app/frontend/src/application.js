require("@rails/ujs").start()
require("@rails/activestorage").start()
require('@rails/actiontext')
require('jquery')
require('trix')
require('materialize')

import './generic'
import './stars'

// CSS
import '../stylesheets/style.scss'

// images
const images = require.context('../images', true)
const imagePath = (name) => images(name, true)

// necessary for js.erb files
import $ from 'jquery';
global.$ = jQuery;