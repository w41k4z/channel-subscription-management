using channel_subscription_management.Models;
using Microsoft.EntityFrameworkCore;

namespace channel_subscription_management.Data
{
    public class AppDbContext : DbContext
    {

        public AppDbContext() { }

        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
        {
        }

        public DbSet<Status> Status { get; set; }
    }
}