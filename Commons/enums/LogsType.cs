using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ISR.Commons.enums
{
    public enum LogsType : byte    
    {
        RegisterInfoByStudent=1 ,
        UploadDocByStudent = 2,
        EditRequestByInternationalExpert = 3,
        RejectRequestByInternationalExpert = 4,
        AcceptRequestByInternationalExpert = 5,
        RejectRequestByInternationalManager = 6,
        EditRequestByInternationalManager = 7,
        FirstAcceptReqeustByInternationalManager = 8,
        FinalAcceptRequestByInternationalManager = 9,
        AcceptRequestByInternationalEnrollment = 10,
        RejectRequestByInternationalEnrollment = 11,
        EditDocByStudent = 12,
        AddRecommenderForStudentByInternationalExpert = 13,
        AddFamilyToStudentByInternationalExpert = 14,
        RemoveFamilyFromStudentByInternationalExpert = 15,
        RejecDocByInternationalExpert = 16,
        AcceptDocByInternationalExpert = 17,
        AddDocAndAcceptByInternationalExpert = 18,
        AddNewStudentCondidateFieldByInternationalExpert = 19,
        RemoveStudentCondidateFieldByInternationalExpert = 20,
        SelectMainFieldInCondidateFieldsByInternationalExpert = 21,
    }
}
