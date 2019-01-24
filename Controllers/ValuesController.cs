using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace LPT_project.Controllers
{
    public class ValuesController : ApiController
    {
        //public string ConvertDataTabletoString(DataTable dt)
        //{
        //    System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
        //    List<Dictionary<string, object>> rows = new List<Dictionary<string, object>>();
        //    Dictionary<string, object> row;
        //    foreach (DataRow dr in dt.Rows)
        //    {
        //        row = new Dictionary<string, object>();
        //        foreach (DataColumn col in dt.Columns)
        //        {
        //            row.Add(col.ColumnName, dr[col]);
        //        }
        //        rows.Add(row);
        //    }
        //    return serializer.Serialize(rows);
        //}
        
        public string GetSavePerson(string personid, string firstname, string lastname)
        {
            string retunvalue = "false";
            DataTable datatable = GetDataTable("Exec upsPersonSearch '" + personid + "','" + firstname + "','" + lastname + "'");
            if (datatable.Rows.Count > 0)
            {
                retunvalue = "true";
            }
            return retunvalue;
        }

        // POST: api/Values
        public void Post([FromBody]string value)
        {
        }

        // PUT: api/Values/5
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE: api/Values/5
        public void Delete(int id)
        {
        }

        private DataTable GetDataTable(string query)
        {
            DataTable dt = new DataTable();
            string constr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand(query))
                {
                    using (SqlDataAdapter sda = new SqlDataAdapter())
                    {
                        cmd.CommandType = CommandType.Text;
                        cmd.Connection = con;
                        sda.SelectCommand = cmd;
                        sda.Fill(dt);
                        con.Close();
                        con.Dispose();
                        cmd.Dispose();
                    }
                }
                return dt;
            }
        }
    }
}
