
enum StatesEvents { completed, cancel, add, edit, subtract }

class EventsName {
  //////////////////// Error Actions
  static const handledException = "Handled-Exception";

  static const unhandledUIException = "Unhandled-UI-Exception";
  static const unhandledAsynchronousException = "Unhandled-Asynchronous-Exception";
  static const unExpectedJsonType = "UnExpected-Json-Type-Exception";


  static const requestAPISuccessful = "Response-API-Successful";
  static const requestAPIError = "Response-API-Error";

}
