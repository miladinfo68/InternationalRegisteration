
namespace ISR.web.Models
{
    public class UserViewModel
    {
        public decimal Id { get; set; }
        public string Username { get; set; }
        public string DisplayName { get; set; }
        public string Password { get; set; }
        public bool Active { get; set; }

        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string AccountMobile { get; set; }
        public string AccountMobileCode { get; set; }
        public string AccountEmail { get; set; }
    }
}