using Microsoft.AspNetCore.Identity.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Text;
using  cclapi.Data;

namespace cclapi.Controllers
{
    [Route("api/Auth/[controller]")]
    [ApiController]
    public class LoginController(IConfiguration config, AppDbContext context) : ControllerBase
    {
        private readonly IConfiguration _config = config;
        private readonly AppDbContext _context = context;

        [HttpPost]
        public IActionResult Post([FromBody] LoginRequest loginRequest)
        {
            //  Check if user is in the database
            var user = _context.Usuarios.FirstOrDefault(x => x.Email == loginRequest.Email && x.Contraseña == loginRequest.Password);

            if (user == null)
            {
                return Unauthorized("Invalid username or password");
            }
            
            //If login usrename and password are correct then proceed to generate token

            var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_config["JwtSettings:Key"]!));
            var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

            var Sectoken = new JwtSecurityToken(_config["JwtSettings:Issuer"],
              _config["JwtSettings:Audience"],
              null,
              expires: DateTime.Now.AddMinutes(120),
              signingCredentials: credentials);

            var token =  new JwtSecurityTokenHandler().WriteToken(Sectoken);

            return Ok(token);
        }
    }
}