import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/apis/api_info.dart';

import 'package:balady_plus/app/features/_shared_feature_/data/models/response_body_model.dart';
import 'package:balady_plus/app/features/chatbot/data/models/chat_bot_message.dart';
// import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatBotProvider extends BaseViewModel {
  final WebService repository;

  ScrollController scrollController = ScrollController();

  ValueNotifier<List<ChatBotMessage>> chatBotMessage =
      ValueNotifier<List<ChatBotMessage>>([]);

  ChatBotProvider(this.repository);

  Future sendQuestion(String question) async {
    isLoading = true;
    notifyListeners();
    // Response? response;
    try {
      http.Response response = await http.post(
        Uri.parse('https://apiservicesstg.balady.gov.sa/v1/chatbot-services/chat'),
        body: jsonEncode({"question": question}),
        headers: {
          "session-id": "001c44b8-2eee-415a-912d-601616e724be",
          'Content-Type': 'application/json',
          // "Accept":"application/json",
          "Authorization" : "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjhFRDBCN0UzRjNDOTFBOEQwMUU3MEMxRUM4MTNGQTJBRjgxOEQ5MUZSUzI1NiIsIng1dCI6Imp0QzM0X1BKR28wQjV3d2V5QlA2S3ZnWTJSOCIsInR5cCI6ImF0K2p3dCJ9.eyJpc3MiOiJodHRwczovL3Nzb2FwcGRldi5tb21yYS5nb3Yuc2EiLCJuYmYiOjE3MDM1ODEzNDAsImlhdCI6MTcwMzU4MTM0MCwiZXhwIjoxNzA0NzkwOTQwLCJhdWQiOlsiRW1wbG95ZWVBZG1pbnN0cmF0aW9uLkFwaSIsImh0dHBzOi8vc3NvYXBwZGV2Lm1vbXJhLmdvdi5zYS9yZXNvdXJjZXMiXSwic2NvcGUiOlsib3BlbmlkIiwicHJvZmlsZSIsIkVtcGxveWVlQWRtaW5zdHJhdGlvbi5BcGkiLCJvZmZsaW5lX2FjY2VzcyJdLCJhbXIiOlsicHdkIl0sImNsaWVudF9pZCI6ImJhbGFkeV9tb2JpbGVfYXBwIiwic3ViIjoiMWVjZDY2NTYtMzlhMC00YmFkLTg2OWQtNjIxZGFmNWY4YmYyIiwiYXV0aF90aW1lIjoxNzAzNTgwOTk0LCJpZHAiOiJsb2NhbCIsImVtYWlsIjoibWFpbEBtb21yYWguZ292LnNhIiwicm9sZSI6WyJSb2xlX0xpY2Vuc2VBZ2VuY3kiLCJJbnN0aXR1dGVzIiwiQmFsYWR5X0FkbWluX01vYmlsZSIsIkJhbGFkeV9PdGhlciIsIkxpY2Vuc2VTdGFuZGFyZEFjdGl2aXR5QWRtaW4iLCJDQU5fU0tJUF9DT09LSUVfVkFMSURBVE9SIiwiTGljZW5zZVN0YW5kYXJkQWN0aXZpdHlEYXRhRW50cnkiXSwicGhvbmVfbnVtYmVyIjoiNTQyMDAyMTgwIiwibmFtZSI6IjEwMDU4MzAwODYiLCJ0aWQiOiIyMTMiLCJ0bm0iOiLYo9mF2KfZhtipINin2YTZhdiv2YrZhtipINin2YTZhdmG2YjYsdipIiwibWFpbCI6Im1haWxAbW9tcmFoLmdvdi5zYSIsInNleCI6IjEiLCJkb2IiOiIwNy8wOC8xOTc2IiwicGhvbmUiOiIwNTQyMDAyMTgwIiwiYXJfbmFtZSI6Iti52KjYr9in2YTZhNmHINi02KfZgdmKINi52YLZitmEINin2YTYudmG2LLZiiIsImVuX25hbWUiOiJBQkRVTExBSCBTSEFGSSBBIEFMQU5BWkkiLCJpZF9ubyI6IjEwMDU4MzAwODYiLCJuaWQiOiIxMTMiLCJuYXRpb25hbGl0eSI6Itiz2LnZiNiv2YoiLCJpZF90eXBlIjoiMSIsInNuYW1lIjoi2LnYqNiv2KfZhNmE2Ycs2LTYp9mB2Yos2LnZgtmK2YQs2KfZhNi52YbYstmKIiwidGVuYW50cyI6Ilt7XCJUZW5hbnROYW1lXCI6XCLYo9mF2KfZhtipINin2YTZhdiv2YrZhtipINin2YTZhdmG2YjYsdipXCIsXCJUZW5hbnRJZFwiOjIxMyxcIlRlbmFudFR5cGVcIjpcInRlbmFudFwiLFwiR292SWRcIjpudWxsLFwiSXNEZWZhdWx0VGVuYW50XCI6ZmFsc2V9LHtcIlRlbmFudE5hbWVcIjpcItio2YTYr9mK2Kkg2LrYsdioINi52LHYudixXCIsXCJUZW5hbnRJZFwiOjU1NSxcIlRlbmFudFR5cGVcIjpudWxsLFwiR292SWRcIjpudWxsLFwiSXNEZWZhdWx0VGVuYW50XCI6ZmFsc2V9LHtcIlRlbmFudE5hbWVcIjpcItmI2LLYp9ix2Kkg2KfZhNi02KbZiNmGINin2YTYqNmE2K_ZitipINmI2KfZhNmC2LHZiNmK2Kkg2YjYp9mE2KfYs9mD2KfZhlwiLFwiVGVuYW50SWRcIjoxMjEyLFwiVGVuYW50VHlwZVwiOm51bGwsXCJHb3ZJZFwiOm51bGwsXCJJc0RlZmF1bHRUZW5hbnRcIjpmYWxzZX0se1wiVGVuYW50TmFtZVwiOlwi2KPZhdin2YbYqSDZhdmG2LfZgtipINin2YTYp9it2LPYp9ihXCIsXCJUZW5hbnRJZFwiOjE5MyxcIlRlbmFudFR5cGVcIjpudWxsLFwiR292SWRcIjpudWxsLFwiSXNEZWZhdWx0VGVuYW50XCI6ZmFsc2V9LHtcIlRlbmFudE5hbWVcIjpcItij2YXYp9mG2Kkg2YXZhti32YLYqSDYrdin2KbZhFwiLFwiVGVuYW50SWRcIjozNyxcIlRlbmFudFR5cGVcIjpudWxsLFwiR292SWRcIjpudWxsLFwiSXNEZWZhdWx0VGVuYW50XCI6ZmFsc2V9LHtcIlRlbmFudE5hbWVcIjpcItio2YTYr9mK2Kkg2KfZhNi52YXYsdipINin2YTZgdix2LnZitipXCIsXCJUZW5hbnRJZFwiOjE4MCxcIlRlbmFudFR5cGVcIjpudWxsLFwiR292SWRcIjpudWxsLFwiSXNEZWZhdWx0VGVuYW50XCI6ZmFsc2V9LHtcIlRlbmFudE5hbWVcIjpcItij2YXYp9mG2Kkg2YXZhti32YLYqSDZhtis2LHYp9mGXCIsXCJUZW5hbnRJZFwiOjksXCJUZW5hbnRUeXBlXCI6bnVsbCxcIkdvdklkXCI6bnVsbCxcIklzRGVmYXVsdFRlbmFudFwiOmZhbHNlfSx7XCJUZW5hbnROYW1lXCI6XCLYo9mF2KfZhtipINin2YTYrdiv2YjYryDYp9mE2LTZhdin2YTZitipXCIsXCJUZW5hbnRJZFwiOjEsXCJUZW5hbnRUeXBlXCI6bnVsbCxcIkdvdklkXCI6bnVsbCxcIklzRGVmYXVsdFRlbmFudFwiOmZhbHNlfSx7XCJUZW5hbnROYW1lXCI6XCLYo9mF2KfZhtipINmF2YbYt9mC2Kkg2KzYp9iy2KfZhlwiLFwiVGVuYW50SWRcIjoyMCxcIlRlbmFudFR5cGVcIjpudWxsLFwiR292SWRcIjpudWxsLFwiSXNEZWZhdWx0VGVuYW50XCI6ZmFsc2V9XSIsImJtYWlsIjoiIiwic2lkIjoiQjhBNDUzQzg5QUFDQjVDRDcxN0IzOTA1N0U3NkI1QkUiLCJqdGkiOiI3NTY5MEQzOUI1MjAxMjhBQUZDRERFOEEwOUJCMzQ3NyJ9.EZLOkMZKLJQRBCW1JhsoJm8Yw2_5SbEBo3rbGdfmv0OI6O1TvpHWyfK2B0TAL1omESqqnwel-tpVpZg1k9Mz3qNaJNPGoNDTYT1M9BAFvK5U9G7slmdBRvmETBnJe8kVWgERHELHJDIc7xDV66ussJriUjWT_OAumx478G7WXz3dKM0T6-_90KjUX9di2G1VKNGdganLsFq0skWy4D-ngjBmuZZo_VIysw2ZV_riIEgSjZy3lnSMWQuPZKILw3hJAIEBBn9oGDtx3b0JKVOc_Q5x4Zr0-icXiJZtlRYowRydYpFlcxuJrGbRkUAouSbSTSIPoqRwuX9FglkJK1psFw",
          // "authorization" : "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjhFRDBCN0UzRjNDOTFBOEQwMUU3MEMxRUM4MTNGQTJBRjgxOEQ5MUZSUzI1NiIsIng1dCI6Imp0QzM0X1BKR28wQjV3d2V5QlA2S3ZnWTJSOCIsInR5cCI6ImF0K2p3dCJ9.eyJpc3MiOiJodHRwczovL3Nzb2FwcGRldi5tb21yYS5nb3Yuc2EiLCJuYmYiOjE3MDM1MDUyODgsImlhdCI6MTcwMzUwNTI4OCwiZXhwIjoxNzA0NzE0ODg4LCJhdWQiOlsiRW1wbG95ZWVBZG1pbnN0cmF0aW9uLkFwaSIsImh0dHBzOi8vc3NvYXBwZGV2Lm1vbXJhLmdvdi5zYS9yZXNvdXJjZXMiXSwic2NvcGUiOlsib3BlbmlkIiwicHJvZmlsZSIsIkVtcGxveWVlQWRtaW5zdHJhdGlvbi5BcGkiLCJvZmZsaW5lX2FjY2VzcyJdLCJhbXIiOlsicHdkIl0sImNsaWVudF9pZCI6ImJhbGFkeV9tb2JpbGVfYXBwIiwic3ViIjoiMDA1MzM0NGMtMTJlYi00YTk5LTkzMzItZThlZjU1NWJjNDliIiwiYXV0aF90aW1lIjoxNzAzNTAyNzQ5LCJpZHAiOiJsb2NhbCIsImVtYWlsIjoiYWFsYnVoYXlyaUBtb21yYWguZ292LnNhIiwicGhvbmVfbnVtYmVyIjoiNTY4NjE2OTE5IiwibmFtZSI6IjEwNDgyNzM2OTAiLCJ0aWQiOiIzNTYiLCJ0bm0iOiLYqNmE2K_ZitipINi02YXYp9mEINin2YTYsdmK2KfYtiIsImdvdmlkIjoiNzI1NyIsIm1haWwiOiJhYWxidWhheXJpQG1vbXJhaC5nb3Yuc2EiLCJzZXgiOiIxIiwiZG9iIjoiMTYvMDQvMTk4NSIsInBob25lIjoiMDU2ODYxNjkxOSIsImFyX25hbWUiOiLZhdit2YXYryDYs9in2YTZhSDZhdi52YrZhiDYp9mE2YXYt9mK2LHZiiIsImVuX25hbWUiOiLZhdit2YXYryDYs9in2YTZhSDZhdi52YrZhiDYp9mE2YXYt9mK2LHZiiIsImlkX25vIjoiMTA0ODI3MzY5MCIsIm5pZCI6IjExMyIsIm5hdGlvbmFsaXR5Ijoi2LPYudmI2K_ZiiIsImlkX3R5cGUiOiIxIiwic25hbWUiOiLZhdit2YXYryzYs9in2YTZhSzZhdi52YrZhizYp9mE2YXYt9mK2LHZiiIsInRlbmFudHMiOiJbe1wiVGVuYW50TmFtZVwiOlwi2YjYstin2LHYqSDYp9mE2LTYptmI2YYg2KfZhNio2YTYr9mK2Kkg2YjYp9mE2YLYsdmI2YrYqSDZiNin2YTYp9iz2YPYp9mGXCIsXCJUZW5hbnRJZFwiOjEyMTIsXCJUZW5hbnRUeXBlXCI6bnVsbCxcIkdvdklkXCI6bnVsbCxcIklzRGVmYXVsdFRlbmFudFwiOmZhbHNlfSx7XCJUZW5hbnROYW1lXCI6XCLYqNmE2K_ZitipINi02YXYp9mEINin2YTYsdmK2KfYtlwiLFwiVGVuYW50SWRcIjozNTYsXCJUZW5hbnRUeXBlXCI6bnVsbCxcIkdvdklkXCI6NzI1NyxcIklzRGVmYXVsdFRlbmFudFwiOnRydWV9LHtcIlRlbmFudE5hbWVcIjpcItio2YTYr9mK2Kkg2KfZhNi52YTZitinXCIsXCJUZW5hbnRJZFwiOjM1MSxcIlRlbmFudFR5cGVcIjpudWxsLFwiR292SWRcIjo3MjU3LFwiSXNEZWZhdWx0VGVuYW50XCI6ZmFsc2V9LHtcIlRlbmFudE5hbWVcIjpcItij2YXYp9mG2Kkg2YXZhti32YLYqSDYp9mE2LHZitin2LZcIixcIlRlbmFudElkXCI6MzIxLFwiVGVuYW50VHlwZVwiOm51bGwsXCJHb3ZJZFwiOjcyNTcsXCJJc0RlZmF1bHRUZW5hbnRcIjpmYWxzZX1dIiwiYm1haWwiOiIiLCJzaWQiOiJFNUFGQUYwRDZENUUwREMyNEI2OEMwQTE4N0FBQjQzRSIsImp0aSI6Ijg4MTNFRTNDQkFDODM5Q0E1NjQ4OTYwMURCNzYwNEJBIn0.Y7YM-mMIT7iG276t7vdo3ajy9shG97YbCcMzntPC4Q4JQh92yf0d_oO7LCc_gYzxs4t20fvbo1bRUYYYOY0omZxsV8VKg9s2Kd8GnXAm1hs0w_t6HvxmJDf4RO7Dq_oJxF6-wuJ6J1htmmUCpH2cGxv54ghSjQMcYphxVeEbaJnS8CO9165woUczjya9REHD-Yu7W1s1sF54vssQPgi3vf07gGYU-PaAa82nbX8IDRGicZE1eqn-S7Ev_oJ6TIoz4wMM_Z4yJaIASagVqCf9nyVkSXdEVErx2Nl5OSsGrHsl6RgEOZs83sbP8012nkvblr5NaF2EiA24i3rlDNsdpg",
        },
      );
      final data = response.body;
      // final result = ResponseBodyModel.fromMap(data).data?.result;
      isLoading = false;
      // setMessage(ChatBotMessage(message: result, isResponse: true));
      notifyListeners();
      return chatBotMessage;
    } on Exception catch (exception) {
      CommonFunctions.sendEvent(
        // dioError: exception is DioException ? exception : null,
        // response: response,
        ex: exception,
      );
      setMessage(
        ChatBotMessage(
          message: exception.toString(),
          isResponse: true,
          haveError: true,
        ),
      );
    } catch (exception) {
      CommonFunctions.sendEvent(
        dioError: null,
        // response: response,
        ex: Exception(exception.toString()),
      );
      setMessage(
        ChatBotMessage(
          message: exception.toString(),
          isResponse: true,
          haveError: true,
        ),
      );
    }
    isLoading = false;
    notifyListeners();
    return chatBotMessage;
  }

  void setMessage(ChatBotMessage message) {
    chatBotMessage.value.add(message);
    chatBotMessage.notifyListeners();
    scrollController.animateTo(
      scrollController.position.maxScrollExtent + 150,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }
}
