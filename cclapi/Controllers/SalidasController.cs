using Microsoft.AspNetCore.Mvc;
using cclapi.Models;
using cclapi.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authorization;

namespace cclapi.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class SalidasController(AppDbContext context) : ControllerBase
    {
        private readonly AppDbContext _context = context;

        // GET: api/Salidas
        [HttpGet]
        public async Task<ActionResult<IEnumerable<SalidaProductos>>> GetSalidaProducto()
        {
            return await _context.SalidaProductos.ToListAsync();
        }
    }
}