// license management status
enum LicenseManagementStatus {
  none,
  draft,
  done,
  cancelled,
  sadadBillIssued,
  rejected,
  waitingPayProccess,
  waitingMedicalExam,
  waitingMedicalTraining,
  waitingEmployeeVisit,
  buyBag,
  goToCourse,
  passedAndCompletedTraining,
  failed,
  reciptForRetest,

  active,
  canceled,
  holded,
  EXPIRED,
  pendingRequestExists,

  underProcedure,
  valid,
  revoked,
  completed,
  expired,
  awaitPayment,
  donePayment,
}

// license management types
enum LicenseManagementTypes { license, order, bill }

// submit license types
enum SubmitLicenseTypes { newLicense, renewLicense, cancelLicense, editLicense, transferLicense, printLicense }
