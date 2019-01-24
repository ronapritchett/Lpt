using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LPT_project
{
    public partial class LPT : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            GridView1.RowDataBound += GridView1_RowDataBound;

            if (!Page.IsPostBack)
            {
                DataTable datatable = GetDataTable("Exec upsPersonSearch 0,'',''");

                if (datatable.Rows.Count == 0)
                {
                    datatable.Rows.Add();
                }

                Session["TaskTable"] = datatable;
                GridView1.DataSource = datatable;
                GridView1.DataBind();
            }

            GridView1.Sorting += GridView1_Sorting;
            GridView1.PageIndexChanging += GridView1_PageIndexChanging;
            GridView1.RowEditing += GridView1_RowEditing;
            GridView1.RowCancelingEdit += GridView1_RowCancelingEdit;
            GridView1.RowCommand += GridView1_RowCommand;
            
            GetStates();
        }

        private void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType.ToString() == "DataRow")
            {
                if (e.Row.Cells[2].Text == "&nbsp;")
                {
                    e.Row.Visible = false;
                }
            }
        }

        private void GetStates()
        {
            if (!Page.IsPostBack)
            {
                DataTable datatable = GetDataTable("Exec upsStateList");
                ddstate.DataValueField = "state_id";
                ddstate.DataTextField = "state_code";
                ddstate.DataSource = datatable;
                ddstate.DataBind();
            }
        }

        protected void search_Click(object sender, EventArgs e)
        {
            DataTable datatable = GetDataTable("Exec upsPersonSearch 0,'" + firstname.Text.ToString().Trim() + "','" + lastname.Text.ToString().Trim() + "'");
            Session["TaskTable"] = datatable;
            GridView1.DataSource = datatable;
            GridView1.DataBind();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (Page.IsPostBack)
            {
                DataTable dt = (DataTable)Session["TaskTable"];
                DataTable datareturn = GetDataTable("EXEC upsPersonUpsert '" + hiddenperson_id.Value + "','" + txtfirstname.Text + "','" + txtlastname.Text + "','" + ddstate.SelectedValue + "','" + ddgender.SelectedValue + "','" + txtdobtext.Text + "'");

                string person_id = "0";

                if (datareturn.Rows.Count > 0)
                {
                    person_id = datareturn.Rows[0]["person_id"].ToString();
                    int _rowindex = 0;

                    if ((datareturn.Rows[0]["action"].ToString() == "INSERT") || (rowindex.Value.ToString() == ""))
                    {
                        dt.Rows.Add();
                        rowindex.Value = GridView1.Rows.Count.ToString();
                        _rowindex = GridView1.Rows.Count;
                    }
                    else
                    {
                        GridViewRow row = GridView1.Rows[Int32.Parse(rowindex.Value.ToString())];
                        _rowindex = row.DataItemIndex;
                    }

                    dt.Rows[_rowindex]["person_id"] = datareturn.Rows[0]["person_id"].ToString();
                    dt.Rows[_rowindex]["first_name"] = txtfirstname.Text;
                    dt.Rows[_rowindex]["last_name"] = txtlastname.Text;
                    dt.Rows[_rowindex]["state_id"] = ddstate.SelectedValue;
                    dt.Rows[_rowindex]["state_code"] = ddstate.SelectedItem.Text;
                    dt.Rows[_rowindex]["gender"] = ddgender.SelectedItem.Text;
                    dt.Rows[_rowindex]["dob"] = txtdobtext.Text;

                    Session["TaskTable"] = dt;
                    GridView1.EditIndex = -1;

                    BindData();
                }

                ClientScript.RegisterStartupScript(this.GetType(), "Save", "btnSave_Click2('" + person_id + "','" + txtfirstname.Text + "','" + txtlastname.Text + "');", true);
            }
        }

        private void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ShowPopup")
            {
                LinkButton btndetails = (LinkButton)e.CommandSource;
                GridViewRow gvrow = (GridViewRow)btndetails.NamingContainer;

                rowindex.Value = gvrow.RowIndex.ToString();
                hiddenperson_id.Value = HttpUtility.HtmlDecode(gvrow.Cells[1].Text);
                txtfirstname.Text = HttpUtility.HtmlDecode(gvrow.Cells[2].Text);
                txtlastname.Text = HttpUtility.HtmlDecode(gvrow.Cells[3].Text);
                ddstate.Text = HttpUtility.HtmlDecode(gvrow.Cells[4].Text);
                if (HttpUtility.HtmlDecode(gvrow.Cells[6].Text) == "Male")
                {
                    ddgender.Text = "M";
                }
                else
                {
                    ddgender.Text = "F";
                }
                txtdobtext.Text = HttpUtility.HtmlDecode(gvrow.Cells[7].Text);

                caldob.SelectedDate = DateTime.Parse(HttpUtility.HtmlDecode(gvrow.Cells[7].Text));
                caldob.TodaysDate = DateTime.Parse(HttpUtility.HtmlDecode(gvrow.Cells[7].Text));

                Popup(true);
            }
            else if (e.CommandName == "AddPopup")
            {
                hiddenperson_id.Value = "0";
                txtfirstname.Text = "";
                txtlastname.Text = "";
                ddgender.Text = "";
                txtdobtext.Text = "";

                caldob.SelectedDate = DateTime.Now;
                caldob.TodaysDate = DateTime.Now;

                Popup(true);
            }
        }

        void Popup(bool isDisplay)
        {
            StringBuilder builder = new StringBuilder();
            if (isDisplay)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "Pop", "openModal();", true);
            }
            else
            {
                ClientScript.RegisterStartupScript(this.GetType(), "Pop", "hideModal();", true);
            }
        }

        private void GridView1_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            GridView1.EditIndex = -1;
            BindData();
        }

        private void BindData()
        {
            GridView1.DataSource = Session["TaskTable"];
            GridView1.DataBind();
        }

        private void GridView1_RowEditing(object sender, GridViewEditEventArgs e)
        {
            GridView1.EditIndex = e.NewEditIndex;
            BindData();
        }

        private void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridView1.PageIndex = e.NewPageIndex;
            BindData();
        }

        private void GridView1_Sorting(object sender, GridViewSortEventArgs e)
        {
            DataTable dt = Session["TaskTable"] as DataTable;

            if (dt != null)
            {
                dt.DefaultView.Sort = e.SortExpression + " " + GetSortDirection(e.SortExpression);
                GridView1.DataSource = Session["TaskTable"];
                GridView1.DataBind();
            }
        }

        private string GetSortDirection(string column)
        {
            string sortDirection = "ASC";
            string sortExpression = ViewState["SortExpression"] as string;
            if (sortExpression != null)
            {
                if (sortExpression == column)
                {
                    string lastDirection = ViewState["SortDirection"] as string;
                    if ((lastDirection != null) && (lastDirection == "ASC"))
                    {
                        sortDirection = "DESC";
                    }
                }
            }
            ViewState["SortDirection"] = sortDirection;
            ViewState["SortExpression"] = column;
            return sortDirection;
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

        protected void caldob_VisibleMonthChanged(object sender, MonthChangedEventArgs e)
        {
            ClientScript.RegisterStartupScript(this.GetType(), "Pop", "openModal();", true);
        }
    }
}