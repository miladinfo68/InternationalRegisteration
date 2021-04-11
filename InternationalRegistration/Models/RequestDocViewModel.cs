
using System;

namespace ISR.web.Models
{
    public class RequestDocViewModel
    {
        public decimal Id { get; set; }
        public int? Category { get; set; }
        public string CategoryTitle { get; set; }
        public byte? DocStatus { get; set; }
        public string DocStatusTitle { get; set; }
        public string FileName { get; set; }
        public string Path { get; set; }
        public decimal? StudentId { get; set; }
        public string Term { get; set; }
        public Nullable<decimal> Web_msg_stu_Idnaghs { get; set; }
        public string Description { get; set; }
    }
}