using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(LPT_project.Startup))]
namespace LPT_project
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
