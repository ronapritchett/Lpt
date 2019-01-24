<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LPT.aspx.cs" Inherits="LPT_project.LPT" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <script src="Scripts/jquery-1.10.2.js"></script>
    <script src="Scripts/bootstrap.min.js"></script>
    <style type="text/css">
      .hiddencol
      {
        display: none;
      }
    </style>
    <script type="text/javascript">
        function openModal() {
            $('[id*=AddEditModal]').modal('show');
        }
        function hideModal() {
            $('[id*=AddEditModal]').modal('hide');
        }
        function opencalendar1() {          
            $('#caldob').get(0).style.display = "block";
            $('#divdob').get(0).style.display = "none";
        }
        function btnSave_Click2(personid, firstname, lastname) {
            //debugger
            $.ajax({
                cache: false,
                url: 'api/Values/GetSavePerson?personid=' + personid + '&firstname=' + firstname + '&lastname=' + lastname,
                type: 'GET',
                dataType: "json",
                success: function (data) {
                    if (data == "true") {
                        $('#massage').get(0).innerText = "Record saved";
                        $('[id*=AlertModal]').modal('show');
                    }
                    else
                    {
                        $('#massage').get(0).innerText = "Error while saving data";
                        $('[id*=AlertModal]').modal('show');
                    }
                },
                error: function () {
                    $('#massage').get(0).innerText = "Error while saving data";
                    $('[id*=AlertModal]').modal('show');
                }
            });
        }
    </script>
    <script language="C#" runat="server">
        void Selection_Change(Object sender, EventArgs e)
        {
            txtdobtext.Text = caldob.SelectedDate.ToShortDateString();
            caldob.Enabled = false;
            ClientScript.RegisterStartupScript(this.GetType(), "Pop", "openModal();", true);
            caldob.Enabled = true;
        }
   </script>
</head>
<body>
    <form id="form1" class="form-group" runat="server">
    <br />
    <br />
    <div class="container">
         <div class="row">
          <div class="col-md-12">
            <div class="table-responsive">        
                <table>
                    <tr>
                        <td><asp:Label class="form-control" runat="server">First Name:</asp:Label></td>
                        <td><asp:TextBox MaxLength="50" Width="250px" class="form-control" ID="firstname" runat="server"></asp:TextBox></td>
                    </tr> 
                    <tr><td>&nbsp;</td></tr>                
                    <tr>
                        <td><asp:Label class="form-control" runat="server">Last Name:</asp:Label></td>
                        <td><asp:TextBox MaxLength="50" Width="250px" class="form-control" ID="lastname" runat="server"></asp:TextBox></td>
                    </tr>
                    <tr><td>&nbsp;</td></tr>
                    <tr><td style="text-align: center" colspan="2"><asp:Button CssClass="btn btn-default btn-lg" ID="search" runat="server" OnClick="search_Click" Text="Search" /></td></tr>
                </table>                      
                <br />
                <br />
                <asp:GridView ShowFooter="true" CssClass="table table-bordered table-condensed" RowStyle-VerticalAlign="Middle" Width="800px" runat="server" ID="GridView1" ShowHeaderWhenEmpty="True" AllowPaging="true" autogenerateeditbutton="false" autogeneratecolumns="false" AllowSorting="true" PageSize="10">
                    <columns>
                        <asp:TemplateField ItemStyle-VerticalAlign="Middle" HeaderText="">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkBtnEdit" runat="server" Text="Edit" CssClass="btn btn-info" CommandName="ShowPopup"></asp:LinkButton>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:Button ID="lnkBtnAdd" Text="Add" runat="server" CssClass="btn btn-info" CommandName="AddPopup" />
                            </FooterTemplate>
                        </asp:TemplateField>          
                      <asp:boundfield datafield="person_id" headertext="" ItemStyle-CssClass="hiddencol" HeaderStyle-CssClass="hiddencol" FooterStyle-CssClass="hiddencol" />
                      <asp:boundfield datafield="first_name" headertext="First Name"/>
                      <asp:boundfield datafield="last_name" headertext="Last Name"/>
                      <asp:boundfield datafield="state_id" headertext=""  ItemStyle-CssClass="hiddencol" HeaderStyle-CssClass="hiddencol" FooterStyle-CssClass="hiddencol" />
                      <asp:boundfield datafield="state_code" headertext="State"/>
                      <asp:boundfield datafield="gender" headertext="Gender"/>
                      <asp:boundfield datafield="dob" headertext="DOB"/>                      
                    </columns>
                    <RowStyle VerticalAlign="Middle" />
                    <AlternatingRowStyle BackColor="GhostWhite" VerticalAlign="Middle" />
                    <FooterStyle HorizontalAlign="Left" VerticalAlign="Middle" />
                </asp:GridView> 
             </div>
          </div>
         </div>
        </div>

        <div id="AlertModal" class="modal fade">  
            <div class="modal-dialog">  
                <div class="modal-content">  
                    <div class="modal-header">  
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>  
                        <h4 class="modal-title">Message</h4>  
                    </div>  
                    <div class="modal-body">
                        <div class="col-lg-12 col-sm-12 col-md-12 col-xs-12">
                            <div class="form-group">
                                <asp:Label ID="massage" runat="server"></asp:Label>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-info" data-dismiss="modal">OK</button>
                    </div>
                </div>
            </div>
        </div>
             
        <div id="AddEditModal" class="modal fade">  
            <div class="modal-dialog">  
                <div class="modal-content">  
                    <div class="modal-header">  
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>  
                        <h4 class="modal-title">Add / Edit</h4>  
                    </div>  
                    <div class="modal-body">
                        <div class="col-lg-12 col-sm-12 col-md-12 col-xs-12">
                            <div class="form-group">
                                <asp:HiddenField ID="rowindex" runat="server" />
                                <asp:HiddenField ID="hiddenperson_id" runat="server" />
                                <asp:Label ID="lblfirstname" runat="server" Text="First Name"></asp:Label>
                                <asp:TextBox ID="txtfirstname" runat="server" TabIndex="1" MaxLength="50" CssClass="form-control"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <asp:Label ID="lbllastname" runat="server" Text="Last Name"></asp:Label>
                                <asp:TextBox ID="txtlastname" runat="server" TabIndex="2" MaxLength="50" CssClass="form-control"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <asp:Label ID="lblstate" runat="server" Text="State"></asp:Label>
                                <asp:DropDownList ID="ddstate" runat="server" TabIndex="3" CssClass="form-control">
                                </asp:DropDownList>
                            </div>   
                            <div class="form-group">
                                <asp:Label ID="lblgender" runat="server" Text="Gender"></asp:Label>
                                <asp:DropDownList ID="ddgender" runat="server" TabIndex="4" CssClass="form-control">
                                    <asp:ListItem Text="Male" Value="M"></asp:ListItem>
                                    <asp:ListItem Text="Female" Value="F"></asp:ListItem>
                                </asp:DropDownList>
                            </div>                             
                            <div id="divdob" class="form-group">
                                <asp:Label ID="lbldob" runat="server" Text="DOB"></asp:Label><br />
                                <asp:TextBox ID="txtdobtext" runat="server" TabIndex="5" MaxLength="12" CssClass="form-control"></asp:TextBox>
                                <asp:Calendar ID="caldob" runat="server" 
                                    TabIndex="5" style="display:block;z-index:1000" CssClass="form-control"
                                    SelectionMode="Day" Height="250px" 
                                    ShowGridLines="True" OnVisibleMonthChanged="caldob_VisibleMonthChanged"
                                    OnSelectionChanged="Selection_Change">
                                    <SelectedDayStyle BackColor="Yellow" ForeColor="Red"></SelectedDayStyle>                                    
                                </asp:Calendar>
                            </div>
                        </div>
                    </div>  
                    <div class="modal-footer">
                        <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" CssClass="btn btn-info" />
                        <button type="button" class="btn btn-info" data-dismiss="modal">Close</button>
                    </div>
                </div>  
            </div>  
        </div>

    </form>
</body>
</html>
