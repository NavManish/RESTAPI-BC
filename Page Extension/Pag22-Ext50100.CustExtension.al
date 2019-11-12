pageextension 50100 CustExtension extends "Customer List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addlast("&Customer")
        {
            action(RestInsert)
            {
                ApplicationArea = All;
                Caption = 'Rest Item Insert';
                Image = InsertTravelFee;
                PromotedCategory = Process;
                Promoted = true;
                trigger OnAction()
                var
                    RESTCU: Codeunit RestAPIUsage;
                begin
                    RESTCU.RestAPIItemInsert();
                end;
            }
            action(RestSalesInvoiceInsert)
            {
                ApplicationArea = All;
                Caption = 'Rest SalesInvoice Insert';
                Image = InsertTravelFee;
                PromotedCategory = Process;
                Promoted = true;
                trigger OnAction()
                var
                    RESTCU: Codeunit RestAPIUsage;
                begin
                    RESTCU.CreateSalesInv();
                    //RESTCU.CreateSalesInvLine('5fcb76b7-5b31-45b3-93f2-93ff78b235ae');
                end;
            }
        }
    }

    var
        myInt: Integer;
        

}