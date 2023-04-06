using channel_subscription_management.Data;
using channel_subscription_management.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace channel_subscription_management.Controllers;

[ApiController]
[Route("[controller]")]
public class StatusController : ControllerBase
{
    private readonly AppDbContext _context;

    public StatusController(AppDbContext context)
    {
        _context = context;
    }

    public async Task<ActionResult<IEnumerable<Status>>> Index()
    {
        return await _context.Status.ToListAsync();
    }
}