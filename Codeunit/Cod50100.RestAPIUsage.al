codeunit 50100 RestAPIUsage
{
    trigger OnRun()
    begin

    end;

    procedure RestAPIItemInsert()
    var
        // Token Variable
        TokenURL: Text;
        TokenResponse: HttpResponseMessage;
        TokenClient: HttpClient;
        TokenBody: Text;
        TokenContent: HttpContent;
        TokenHeader: HttpHeaders;
        TokenKey: text;
        //REST Variable
        body: JsonObject;
        innerBody: JsonObject;
        JsonTokeninner: JsonToken;
        i: Integer;
        jsonarr: JsonArray;
        Body2: Text;
        URL: Text;
        HttpContent1: HttpContent;
        Client: HttpClient;
        HttpHeader: HttpHeaders;
        Response: HttpResponseMessage;
        Nextbase: text;
        AuthString: Text;
        TypeHelper: codeunit "Type Helper";
    begin
        /*
        // To generate the token start
        TokenURL := 'https://login.windows.net/myerpkalpavruksh.onmicrosoft.com/oauth2/token?resource=https://api.businesscentral.dynamics.com';
        //TokenBody := '{"grant_type": "authorization_code","Email": "mk2019@myerpkalpavruksh.onmicrosoft.com","Password": "nav@1234"}';
        TokenBody := '{"grant_type":"authorization_code"}';
       
        TokenContent.WriteFrom(TokenBody);
        TokenHeader.Clear();
        TokenContent.GetHeaders(TokenHeader);
        TokenHeader.Remove('Content-Type');
        //TokenHeader.Add('Content-Type', 'application/json');
        TokenHeader.Add('Content-Type', 'application/x-www-form-urlencoded');
        if TokenClient.Post(TokenURL, TokenContent, TokenResponse) then begin
            //Message('%1', TokenResponse.HttpStatusCode);
            TokenResponse.Content.ReadAs(TokenKey);
            Message(TokenKey);
        end;
        // To generate the token end
        */
        /*
        TokenURL := 'https://login.windows.net/myerpkalpavruksh.onmicrosoft.com/oauth2/token';
        TokenBody := 'grant_type=client_credentials&resource=https://api.businesscentral.dynamics.com&auth_url=https://login.windows.net/myerpkalpavruksh.onmicrosoft.com/oauth2/authorize?resource=https://api.businesscentral.dynamics.com&client_id=cb0e5c1d-4fb3-4899-8691-d5e1b9a7ca19&client_secret=BD%402*NqraROL%3FQTqpmRAP%3A5lNN3kklQ4&client_authentication&send_client_credentials_in_body';

        TokenContent.WriteFrom(TokenBody);
        TokenHeader.Clear();
        TokenContent.GetHeaders(TokenHeader);
        TokenHeader.Remove('Content-Type');
        //TokenHeader.Add('Content-Type', 'application/json');
        TokenHeader.Add('Content-Type', 'application/x-www-form-urlencoded');
        if TokenClient.Post(TokenURL, TokenContent, TokenResponse) then begin
            //Message('%1', TokenResponse.HttpStatusCode);
            TokenResponse.Content.ReadAs(TokenKey);
            Message(TokenKey);
        end;
        */
                // Create Message Body Start
                body.Add('number', '6024');
                body.Add('displayName', 'Json Item 6024');
                body.Add('type', 'Inventory');
                body.Add('itemCategoryCode', 'DIV');
                body.Add('blocked', false);

                //Body2 := Format('[' + Format(body) + ']');
                Body2 := Format(body);
                //Message('%1', Body2);
                // Create Message Body End

                URL := 'https://api.businesscentral.dynamics.com/v1.0/1eff7461-4eb3-4b3a-a689-a207d821e879/Sandbox/api/beta/companies(64a58343-0cdd-4998-8297-522ac1d0417b)/items';
                TokenKey := 'PdOnqhiCHYovB6sUJ6MuNspO1ZuRpcKvp++oK5cWXKc=';

                HTTPContent1.WriteFrom(Body2);
                HttpHeader.Clear();
                HttpContent1.GetHeaders(HttpHeader);
                HttpHeader.Remove('Content-Type');
                HttpHeader.Add('Content-Type', 'application/json');

                //>> Sending Token for Basic Authentication
                AuthString := STRSUBSTNO('%1:%2', 'MK2019', TokenKey);
                AuthString := TypeHelper.ConvertValueToBase64(AuthString);
                AuthString := STRSUBSTNO('Basic %1', AuthString);
                Client.DefaultRequestHeaders().Add('Authorization', AuthString);
                //<< Sending Token for Basic Authentication  

                // if Client.Post(URL, HttpContent1, Response) then
                //     Message('%1', Response.HttpStatusCode);

                // IF NOT Response.IsSuccessStatusCode THEN
                //     Error('Web service returned error:\\' + 'Status code: %1\' + 'Description: %2',
                //         Response.HttpStatusCode(), Response.ReasonPhrase())
                // ELSE
                //     Message('Status code: %1\' + 'Description: %2',
                //         Response.Content, Response.ReasonPhrase());

                Response.Content().ReadAs(Nextbase);
                //Message(Nextbase);
                ReadItemJson(Nextbase);
        
    end;

    Local procedure ReadItemJson(JsonBodyText: Text)
    var
        ResponseMessage: HttpResponseMessage;
        JsonToken: JsonToken;
        JsonObject: JsonObject;
        JsonArray: JsonArray;
        i: Integer;
    begin
        JsonBodyText := Format('[' + Format(JsonBodyText) + ']');

        // Process JSON response
        if not JsonArray.ReadFrom(JsonBodyText) then
            Error('Invalid response, expected an JSON array as root object');

        for i := 0 to JsonArray.Count() - 1 do begin

            JsonArray.Get(i, JsonToken);

            JsonObject := JsonToken.AsObject();

            if not JsonObject.Get('id', JsonToken) then
                error('Could not find a token with key %1');

            Message('number - %1', GetJsonToken(JsonObject, 'number').AsValue().AsText());
            Message('displayName - %1', GetJsonToken(JsonObject, 'displayName').AsValue().AsText());
            Message('itemCategoryCode - %1', GetJsonToken(JsonObject, 'itemCategoryCode').AsValue().AsText());
            Message('baseUnitOfMeasure.code - %1', SelectJsonToken(JsonObject, '$.baseUnitOfMeasure.code').AsValue().AsText());
            Message('lastModifiedDateTime %1', GetJsonToken(JsonObject, 'lastModifiedDateTime').AsValue().AsDateTime());

        end;
    end;

    procedure GetJsonToken(JsonObject: JsonObject; TokenKey: Text) JsonToken: JsonToken;
    begin
        if not JsonObject.Get(TokenKey, JsonToken) then
            Error('Could not find a token with key %1', TokenKey);
    end;

    procedure SelectJsonToken(JsonObject: JsonObject; Path: Text) JsonToken: JsonToken;
    begin
        if not JsonObject.SelectToken(Path, JsonToken) then
            Error('Could not find a token with path %1', Path)
    end;

    procedure CreateSalesInv()
    var
        //REST Variable
        Jsonbody: JsonObject;
        Jsonbody1: JsonObject;
        Jsonbody2: JsonObject;
        HttpContent1: HttpContent;
        Client: HttpClient;
        HttpHeader: HttpHeaders;
        Response: HttpResponseMessage;
        Nextbase: text;
        AuthString: Text;
        TypeHelper: codeunit "Type Helper";
        i: Integer;
        jsonarr: JsonArray;
        InvID: Text[100];
        TokenKey: text;
        BodyText: Text;
        SalesInvURL: Text;
    begin
        // Create Message Body Start
        Jsonbody.Add('invoiceDate', '2019-11-09');
        Jsonbody.Add('dueDate', '2019-12-28');
        Jsonbody.Add('customerNumber', '30000');

        Jsonbody2.Add('street', 'Jomfru Ane Gade 56');
        Jsonbody2.Add('city', 'Koge');
        Jsonbody2.Add('countryLetterCode', 'DK');
        Jsonbody2.Add('postalCode', '4600');

        Jsonbody.Add('billingPostalAddress', Jsonbody2.AsToken());
        Jsonbody.WriteTo(bodytext);

        //jsonarr.Add(Jsonbody);
        // jsonarr.WriteTo(BodyText);
        // Message('%1', Bodytext);
        SalesInvURL := 'https://api.businesscentral.dynamics.com/v1.0/1eff7461-4eb3-4b3a-a689-a207d821e879/Sandbox/api/beta/companies(64a58343-0cdd-4998-8297-522ac1d0417b)/salesInvoices';
        TokenKey := 'PdOnqhiCHYovB6sUJ6MuNspO1ZuRpcKvp++oK5cWXKc=';
        HttpContent1.WriteFrom(BodyText);
        HttpHeader.Clear();
        HttpContent1.GetHeaders(HttpHeader);
        HttpHeader.Remove('Content-Type');
        HttpHeader.Add('Content-Type', 'application/json');

        //>> Sending Token for Basic Authentication
        AuthString := STRSUBSTNO('%1:%2', 'MK2019', TokenKey);
        AuthString := TypeHelper.ConvertValueToBase64(AuthString);
        AuthString := STRSUBSTNO('Basic %1', AuthString);
        Client.DefaultRequestHeaders().Add('Authorization', AuthString);
        //<< Sending Token for Basic Authentication 

        if not Client.Post(SalesInvURL, HttpContent1, Response) then begin
            IF NOT Response.IsSuccessStatusCode THEN
                Error('Web service returned error:\\' + 'Status code: %1\' + 'Description: %2',
                    Response.HttpStatusCode(), Response.ReasonPhrase())
        end;
        Response.Content().ReadAs(Nextbase);
        ReadGeneratedInv(InvID, Nextbase);
        CreateSalesInvLine(InvID);
    end;

    local procedure ReadGeneratedInv(var _INVID: Text[100]; JsonbodyText: text)
    var
        ResponseMessage: HttpResponseMessage;
        JsonToken: JsonToken;
        JsonObject: JsonObject;
        JsonArray: JsonArray;
        i: Integer;
    begin
        JsonBodyText := Format('[' + Format(JsonBodyText) + ']');
        //Process Json Response
        if not JsonArray.ReadFrom(JsonbodyText) then
            Error('Invalid response, expected an JSON array as root object');

        for i := 0 to JsonArray.Count() - 1 do begin
            JsonArray.Get(i, JsonToken);
            JsonObject := JsonToken.AsObject();

            if not JsonObject.Get('id', JsonToken) then
                error('Could not find a token with key %1');

            _INVID := GetJsonToken(JsonObject, 'id').AsValue().AsText();
        end;
    end;

    procedure CreateSalesInvLine(_INVID: Text[100])
    var
        //REST Variable
        Jsonbody: JsonObject;
        Jsonbody1: JsonObject;
        Jsonbody2: JsonObject;
        HttpContent1: HttpContent;
        Client: HttpClient;
        HttpHeader: HttpHeaders;
        Response: HttpResponseMessage;
        AuthString: Text;
        TypeHelper: codeunit "Type Helper";
        i: Integer;
        sequence: Integer;
        jsonarr: JsonArray;
        TokenKey: text;
        BodyText: Text;
        SalesInvlineURL: Text;
    begin
        _INVID := '(' + _INVID + ')';
        Jsonbody.Add('sequence', 0);
        Jsonbody.Add('itemId', '');
        Jsonbody.Add('unitPrice', 0);
        Jsonbody.Add('lineType', '');
        Jsonbody.Add('quantity', 0);
        Jsonbody1.Add('number', '');
        Jsonbody.Add('lineDetails', '');

        Jsonbody2.Add('code', '');
        Jsonbody2.Add('displayName', '');
        Jsonbody.Add('unitOfMeasure', '');
        //for i := 1 to 3 do begin
        sequence += 10000;
        // Create Message Body Start
        // Jsonbody.Replace('sequence', sequence);
        // Jsonbody.Replace('itemId', 'ee97b09d-1ead-4342-9460-01ae70e1c19c');
        // Jsonbody.Replace('unitPrice', 1050.50);
        // Jsonbody.Replace('lineType', 'Item');
        // Jsonbody.Replace('quantity', 3);
        // Jsonbody1.Replace('number', '1960-S');
        // Jsonbody.Replace('lineDetails', Jsonbody1.AsToken());

        // Jsonbody2.Replace('code', 'STK');
        // Jsonbody2.Replace('displayName', 'Styk');
        // Jsonbody.Replace('unitOfMeasure', Jsonbody2.AsToken());

        // jsonarr.Add(Jsonbody.Clone());

        Jsonbody.Replace('sequence', sequence);
        Jsonbody.Replace('itemId', 'cfc0f361-a887-4f08-bfcc-f0a3801b4055');
        Jsonbody.Replace('unitPrice', 1050.50);
        Jsonbody.Replace('lineType', 'Item');
        Jsonbody.Replace('quantity', 3);
        Jsonbody1.Replace('number', '1960-S');
        Jsonbody.Replace('lineDetails', Jsonbody1.AsToken());

        Jsonbody2.Replace('code', 'STK');
        Jsonbody2.Replace('displayName', 'Styk');
        Jsonbody.Replace('unitOfMeasure', Jsonbody2.AsToken());

        //end;
        //jsonarr.WriteTo(BodyText);
        // BodyText := DelChr(BodyText, '=', '[');
        // BodyText := DelChr(BodyText, '=', ']');
        Jsonbody.WriteTo(BodyText);

        SalesInvlineURL := 'https://api.businesscentral.dynamics.com/v1.0/1eff7461-4eb3-4b3a-a689-a207d821e879/Sandbox/api/beta/companies(64a58343-0cdd-4998-8297-522ac1d0417b)/salesInvoices' + _INVID + '/salesInvoiceLines';
        TokenKey := 'PdOnqhiCHYovB6sUJ6MuNspO1ZuRpcKvp++oK5cWXKc=';

        HttpContent1.WriteFrom(BodyText);
        HttpHeader.Clear();
        HttpContent1.GetHeaders(HttpHeader);
        HttpHeader.Remove('Content-Type');
        HttpHeader.Add('Content-Type', 'application/json');

        //>> Sending Token for Basic Authentication
        AuthString := STRSUBSTNO('%1:%2', 'MK2019', TokenKey);
        AuthString := TypeHelper.ConvertValueToBase64(AuthString);
        AuthString := STRSUBSTNO('Basic %1', AuthString);
        Client.DefaultRequestHeaders().Add('Authorization', AuthString);
        //<< Sending Token for Basic Authentication 

        if not Client.Post(SalesInvLineURL, HttpContent1, Response) then begin
            IF NOT Response.IsSuccessStatusCode THEN
                Error('Web service returned error:\\' + 'Status code: %1\' + 'Description: %2',
                    Response.HttpStatusCode(), Response.ReasonPhrase())
        end else
            Message('%1', Response.HttpStatusCode);

    end;

    var
        myInt: Integer;
}