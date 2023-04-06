using System.ComponentModel.DataAnnotations.Schema;

namespace channel_subscription_management.Models
{
    public class Status
    {
        [Column("status_id")]
        public int StatusID { get; set; }

        [Column("status_label")]
        public string? StatusLabel { get; set; }

        [Column("status_desc")]
        public string? StatusDescription { get; set; }

        // constructors
        public Status() { }

    }
}