// Generated by CoffeeScript 1.6.2
var GingerAPI, replace_range;

if (String.prototype.format === void 0) {
  String.prototype.format = function(args) {
    var str;

    str = this;
    return str.replace(String.prototype.format.regex, function(item) {
      var i, repl;

      i = parseInt(item.substring(1, item.length - 1));
      if (i >= 0) {
        repl = args[i];
      } else if (i === -1) {
        repl = '{';
      } else if (i === -2) {
        repl = '}';
      } else {
        repl = '';
      }
      return repl;
    });
  };
  String.prototype.format.regex = new RegExp('{-?[0-9]+}', 'g');
}

replace_range = function(text, start, end, repl) {
  var footer, header;

  header = text.substring(0, start);
  footer = text.substring(end);
  return header + repl + footer;
};

GingerAPI = (function() {
  GingerAPI.prototype.base_api_url = 'http://services.gingersoftware.com/Ginger/correct/json/GingerTheText?lang={0}&clientVersion={1}&apiKey={2}&text={3}';

  function GingerAPI(api_key, lang, client_version) {
    if (api_key == null) {
      api_key = '6ae0c3a0-afdc-4532-a810-82ded0054236';
    }
    if (lang == null) {
      lang = 'US';
    }
    if (client_version == null) {
      client_version = '2.0';
    }
    this.api_key = api_key;
    this.lang = lang;
    this.client_version = client_version;
  }

  GingerAPI.prototype.build_url = function(text) {
    return this.base_api_url.format([this.lang, this.client_version, this.api_key, encodeURIComponent(text)]);
  };

  GingerAPI.prototype.clean_response = function(response) {
    return response.slice(2, -2);
  };

  GingerAPI.prototype.send_jQuery = function(api_url, success_func, error_func) {
    return $.ajax({
      success: function(data, textStatus, jqXHR) {
        success_func(data, textStatus, jqXHR);
      },
      error: function(jqXHR, textStatus, errorThrown) {
        error_func(jqXHR, textStatus, errorThrown);
      },
      url: api_url
    });
  };

  GingerAPI.prototype.parse = function(text, json_obj, correct_color, incorrect_color) {
    var correct_text, from, gap, gap_i, incorrect_text, l, result, suggestion, suggestion_i, to, _i, _len, _ref;

    if (correct_color == null) {
      correct_color = '#0099ff';
    }
    if (incorrect_color == null) {
      incorrect_color = '#ff0033';
    }
    correct_text = text;
    incorrect_text = text;
    gap = 0;
    gap_i = 0;
    _ref = json_obj['LightGingerTheTextResult'];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      result = _ref[_i];
      if (result['Suggestions'].length !== 0) {
        from = result['From'];
        to = result['To'];
        l = text.substring(from, to + 1);
        suggestion = '<font color="{0}">' + result['Suggestions'][result['Suggestions'].length - 1]['Text'] + '</font>';
        suggestion_i = '<font color="{0}">' + l + '</font>';
        correct_text = replace_range(correct_text, from + gap, l.length + from + gap, suggestion);
        incorrect_text = replace_range(incorrect_text, from + gap_i, l.length + from + gap_i, suggestion_i);
        gap += suggestion.length - l.length;
        gap_i += suggestion_i.length - l.length;
      }
    }
    correct_text = correct_text.format([correct_color]);
    incorrect_text = incorrect_text.format([incorrect_color]);
    return [correct_text, incorrect_text];
  };

  return GingerAPI;

})();
