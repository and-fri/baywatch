Logs = new Meteor.Collection 'logs'
Settings = new Meteor.Collection 'settings'

Meteor.subscribe 'all_logs'
Meteor.subscribe 'all_settings'
Session.setDefault 'editSet', ''

Template.home.logs = ()->
  return Logs.find({},{sort: {timestamp: -1}})

Template.home.getDate = (mills)->
  date = new Date(mills)
  return date.toString()

Template.helper.settings = ()->
  return Settings.find()

Template.helper.which_span = (life)->
  if life is "1"
    span = "one day"
  else
    if life is "7"
      span = "one week"
    else
      if life is "31"
        span = "one month"
      else if life is "365"
        span = "one year"
      else
        span = "permanent"
  return span

Template.navbar.events
  'click #searchGo' : (e)->
    e.preventDefault()
    tag = $('#search').val().trim()
    if tag? and tag isnt ""
      $('#search').val("")
      console.log tag
      result = Logs.find({}, {logs: tag})
    else
      alert "No empty search"
  'click #settingsGo' : (e)->
    e.preventDefault()
    $('#settings-panel').fadeIn()
    $('#darken').fadeIn()
  'click #add-setting' : (e)->
    e.preventDefault()
    $('#new-setting-panel').fadeIn()
    $('#darken').fadeIn()

Template.helper.events
  'click .close-panels' : (e)->
    e.preventDefault()
    $('.modal').fadeOut()
    $('#darken').fadeOut()
  
  'click #add-setting' : (e)->
    e.preventDefault()
    name = $('#set-name').val().trim()
    life = $('#set-life').val()
    rgx = $('#set-rgx').val().trim().toString()

    if name? and name
      Settings.insert({name: name, life: life, rgx: rgx})
      $('#set-name').val("")
      $("#set-life option[value=-1]").attr("selected", "selected")
      $('#set-rgx').val("")
      $('#new-setting-panel').fadeOut()
      $('#darken').fadeOut()
      console.log name
      console.log life
      console.log rgx
    else
      alert "You have to give the setting one unique name..."
  
  'click .edit-setting-btn' : (e)->
    e.preventDefault()
    self = this
    console.log self

  'click .delete-setting-btn' : (e)->
    e.preventDefault()
    self = this
    if confirm 'Are you sure that you want to delete this setting?'
      Settings.remove({_id: self._id})