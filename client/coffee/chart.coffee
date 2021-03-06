# Temporary fix for chartJS -> switched to bar charts without showing time spans
Template.chart.helpers
  width: ()->
    if $(window).width() < 1200
      return 940
    else
      return 1140

@dataFromLogs = ()->
  allSettings = Settings.find()
  systems = []
  logCounts = []

  allSettings.forEach (setting)->
    systems.push setting.name
    # if Logs.find({'parsed.system':setting.name}).count() > 0
    #   systems.push setting.name
  for system in systems
    count = Logs.find({'parsed.system':system}).count()
    if count > 0
      logCounts.push count
    else
      logCounts.push 0
  data = {
    dataStack: {
      labels : systems,
      datasets : [
        {
          fillColor : "rgba(97,169,220,0.5)",
          strokeColor : "rgba(97,169,120,1)",
          data : logCounts
        }
      ]
    }
  }
  return data
