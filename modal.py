def download_kpprev_csv():
    cache.clear()
    value = flask.request.args.get('value')
    # create a dynamic csv or file here using `StringIO`
    # (instead of writing to the file system)
    #str_io = io.StringIO()
    #str_io.write('You have selected {}'.format(value))
    df_kp = loadKpPrevData()
    str_io = io.StringIO()
    df_kp.to_csv(str_io,index = False)

    mem = io.BytesIO()
    mem.write(str_io.getvalue().encode('utf-8'))
    mem.seek(0)
    return flask.send_file(mem,
                           mimetype='text/csv',
                           attachment_filename='KP_PREV'+datetime.now().strftime("%d%m%y%H%M%S")+'.csv',
                           as_attachment=True)


@app.callback(Output('download-button', 'n_clicks'),
              [Input('modal-close-button', 'n_clicks')])
def close_modal(n):
     return 0

@app.callback(Output('modal', 'style'),
              [Input('download-button', 'n_clicks')])
def show_modal(n):
    if (n is not None) and (n > 0):
        return {"display": "block"}
    return {"display": "none"}


@app.callback([Output('download-button', 'href'),
               Output('download-button', 'download'),
               Output('download-button', 'target')],
              [Input('download-button', 'n_clicks'),Input('period-selector','value')])
def get_pp_link(n,value):
    if (n is not None) and (value is not None) :
        return ["/download_pp_prev",'PP_PREV'+datetime.now().strftime("%d%m%y%H%M%S")+'.csv',"_blank"]
    return["","",""]


    modal=html.Div([  # modal div
            html.Div([

             # content div
                html.Div(id="info" ,children=[
                    'Please select a period first!',
                ]),
                #html.Div(id="line"),
                html.Button('Ok', id='modal-close-button')
            ],
                className='modal-content',
            ),
        ],
            id='modal',
            className='modal',
            style={"display": "none"},
        )
