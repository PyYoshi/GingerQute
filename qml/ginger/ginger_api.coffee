if(String.prototype.format == undefined )
  String.prototype.format = (args)->
    str = this
    return str.replace(
      String.prototype.format.regex
      (item)->
        i = parseInt(item.substring(1, item.length-1))
        if(i >= 0)
          repl = args[i]
        else if(i == -1)
          repl = '{'
        else if(i == -2)
            repl = '}'
        else
          repl = ''
        return repl
    )
  String.prototype.format.regex = new RegExp('{-?[0-9]+}', 'g')

replace_range = (text, start, end, repl)->
  header = text.substring(0, start)
  footer = text.substring(end)
  return header + repl + footer

class GingerAPI
  base_api_url: 'http://services.gingersoftware.com/Ginger/correct/json/GingerTheText?lang={0}&clientVersion={1}&apiKey={2}&text={3}'

  constructor: (api_key='6ae0c3a0-afdc-4532-a810-82ded0054236', lang='US', client_version='2.0')->
    @api_key = api_key
    @lang = lang
    @client_version = client_version

  build_url: (text)->
    return @base_api_url.format([@lang, @client_version, @api_key, encodeURIComponent(text)])

  clean_response: (response)->
    return response.slice(2,-2)

  send_jQuery: (api_url, success_func, error_func)->
    $.ajax(
      #dataFilter: (data, type)->
      #  return @clean_response(data)
      success: (data, textStatus, jqXHR)->
        success_func(data, textStatus, jqXHR)
        return
      error: (jqXHR, textStatus, errorThrown)->
        error_func(jqXHR, textStatus, errorThrown)
        return
      url: api_url
    )

  parse: (text, json_obj, correct_color='#0099ff', incorrect_color='#ff0033')->
    correct_text = text
    incorrect_text = text
    gap = 0
    gap_i = 0
    for result in json_obj['LightGingerTheTextResult']
      if(result['Suggestions'].length != 0)
        from = result['From']
        to = result['To']
        l = text.substring(from,to+1)
        suggestion = '<font color="{0}">' + result['Suggestions'][result['Suggestions'].length-1]['Text'] + '</font>'
        suggestion_i = '<font color="{0}">' + l + '</font>'
        correct_text = replace_range(correct_text, from+gap, l.length + from+gap, suggestion)
        incorrect_text = replace_range(incorrect_text, from+gap_i, l.length + from+gap_i, suggestion_i)
        gap += suggestion.length - l.length
        gap_i += suggestion_i.length - l.length
    correct_text = correct_text.format([correct_color])
    incorrect_text = incorrect_text.format([incorrect_color])

    return [correct_text,incorrect_text]
