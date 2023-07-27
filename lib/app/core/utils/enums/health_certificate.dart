// license management status
enum LICENSE_MANAGEMENT_STATUS {
  NONE,
  DRAFT,
  DONE,
  CANCELLED,
  SADAD_BILL_ISSUED,
  REJECTED,
  WAITING_PAY_PROCCESS,
  WAITING_MEDICAL_EXAM,
  WAITING_MEDICAL_TRAINING,
  WAITING_EMPLOYEE_VISIT,
  BUY_BAG,
  GO_TO_COURSE,
  PASSED_AND_COMPLETED_TRAINING,
  FAILED,
  RECIPT_FOR_RETEST,

  ACTIVE,
  CANCELED,
  HOLDED,
  EXPIRED,
  PENDING_REQUEST_EXISTS,

  underProcedure,
  valid,
  revoked,
  completed,
  expired,
  awaitPayment,
  donePayment
}

// license management types
enum LICENSE_MANAGEMENT_TYPES { license, order, bill }

// submit license types
enum SUBMIT_LICENSE_TYPES {
  newLicense,
  renewLicense,
  cancelLicense,
  editLicense,
  transferLicense,
  printLicense,
}
