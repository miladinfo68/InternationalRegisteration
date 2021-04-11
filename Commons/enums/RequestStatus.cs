namespace ISR.Commons.enums
{
    public enum RequestStatus:byte
    {
        InfoAdded = 0,
        DocsUploaded = 1,
        InProgress = 2,
        //================
        Ex_Rejected = 3,
        Ex_Accepted = 4,
        //================
        M_Rejected = 5,
        M_First_Accepted = 6,
        M_Final_Accepted = 7,
        //================
        M_Enrollment_Accepted = 8,//insert to sida
        M_Enrollment_Rejected = 9
    }
}
