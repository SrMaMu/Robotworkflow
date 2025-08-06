*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}    https://www.pichincha.com/detalle-producto/simulador-de-credito
${MONTO}    100000
${PLAZO}    24
${TIPO_CREDITO}    Preciso
${TIPO_CREDITO_2}    Linea abierta
${TIPO_CREDITO_3}    Hipotecario vivienda
${PLAZO_MINIMO}    12
${MONTO_MINIMO}    1000

*** Test Cases ***
Simular Credito Preciso
    Open Browser    ${URL}    edge
    Maximize Browser Window
    Wait Until Element Is Visible    xpath=//select[@id='selcProduct']
    Select From List By Label    xpath=//select[@id='selcProduct']    ${TIPO_CREDITO}
    Wait Until Element Is Visible    xpath=//input[@id='txtAmount']
    Input Text    xpath=//input[@id='txtAmount']    ${MONTO}
    Wait Until Element Is Visible    xpath=//input[@id='txtTerm']
    Input Text    xpath=//input[@id='txtTerm']    ${PLAZO}
    Click Button    xpath=//button[@id='btnSimulate']
    Wait Until Page Contains Element    xpath=//div[contains(@class, 'result')]
    Element Should Be Visible    xpath=//div[contains(@class, 'result')]
    Close Browser

Simular Credito Linea Abierta
    Open Browser    ${URL}    edge
    Maximize Browser Window
    Wait Until Element Is Visible    xpath=//select[@id='selcProduct']
    Select From List By Label    xpath=//select[@id='selcProduct']    ${TIPO_CREDITO_2}
    Wait Until Element Is Visible    xpath=//input[@id='txtAmount']
    Input Text    xpath=//input[@id='txtAmount']    ${MONTO}
    Wait Until Element Is Visible    xpath=//input[@id='txtTerm']
    Input Text    xpath=//input[@id='txtTerm']    ${PLAZO}
    Click Button    xpath=//button[@id='btnSimulate']
    Wait Until Page Contains Element    xpath=//div[contains(@class, 'result')]
    Element Should Be Visible    xpath=//div[contains(@class, 'result')]
    Close Browser

Simular Credito Hipotecario Vivienda
    Open Browser    ${URL}    edge
    Maximize Browser Window
    Wait Until Element Is Visible    xpath=//select[@id='selcProduct']
    Select From List By Label    xpath=//select[@id='selcProduct']    ${TIPO_CREDITO_3}
    Wait Until Element Is Visible    xpath=//input[@id='txtAmount']
    Input Text    xpath=//input[@id='txtAmount']    ${MONTO}
    Wait Until Element Is Visible    xpath=//input[@id='txtTerm']
    Input Text    xpath=//input[@id='txtTerm']    ${PLAZO}
    Click Button    xpath=//button[@id='btnSimulate']
    Wait Until Page Contains Element    xpath=//div[contains(@class, 'result')]
    Element Should Be Visible    xpath=//div[contains(@class, 'result')]
    Close Browser

Simular Con Campos Vacios (Negativo)
    Open Browser    ${URL}    edge
    Maximize Browser Window
    Wait Until Element Is Visible    xpath=//input[@id='txtAmount']
    Input Text    xpath=//input[@id='txtAmount']    ""
    Wait Until Element Is Visible    xpath=//input[@id='txtTerm']
    Input Text    xpath=//input[@id='txtTerm']    ""
    Click Button    xpath=//button[@id='btnSimulate']
    Wait Until Page Contains Element    xpath=//div[contains(@class, 'error') or contains(@class, 'error-message') or contains(@role, 'alert')]
    Element Should Be Visible    xpath=//div[contains(@class, 'error') or contains(@class, 'error-message') or contains(@role, 'alert')]
    Close Browser

Simular Con Monto Minimo Permitido (Limite)
    Open Browser    ${URL}    edge
    Maximize Browser Window
    Wait Until Element Is Visible    xpath=//select[@id='selcProduct']
    Select From List By Label    xpath=//select[@id='selcProduct']    ${TIPO_CREDITO}
    Wait Until Element Is Visible    xpath=//input[@id='txtAmount']
    Input Text    xpath=//input[@id='txtAmount']    ${MONTO_MINIMO}
    Wait Until Element Is Visible    xpath=//input[@id='txtTerm']
    Input Text    xpath=//input[@id='txtTerm']    ${PLAZO_MINIMO}
    Click Button    xpath=//button[@id='btnSimulate']
    Wait Until Page Contains Element    xpath=//div[contains(@class, 'result')]
    Element Should Be Visible    xpath=//div[contains(@class, 'result')]
    Close Browser

*** Keywords ***
Open Browser To Simulador
    Open Browser    ${URL}    edge
    Maximize Browser Window

Seleccionar Tipo De Credito
    Wait Until Element Is Visible    xpath=//select[@id='selcProduct']    10s
    Wait Until Element Is Enabled    xpath=//select[@id='selcProduct']    10s
    ${options}=    Get List Items    xpath=//select[@id='selcProduct']
    Log    Opciones disponibles en el select: ${options}
    Select From List By Label    xpath=//select[@id='selcProduct']    ${TIPO_CREDITO}

Ingresar Monto Y Plazo
    Wait Until Element Is Visible    xpath=//input[@id='txtAmount']    10s
    Wait Until Element Is Enabled    xpath=//input[@id='txtAmount']    10s
    Input Text    xpath=//input[@id='txtAmount']    ${MONTO}
    Wait Until Element Is Visible    xpath=//input[@id='txtTerm']    10s
    Wait Until Element Is Enabled    xpath=//input[@id='txtTerm']    10s
    Input Text    xpath=//input[@id='txtTerm']    ${PLAZO}

Presionar Simular
    Click Button    xpath=//button[@id='btnSimulate']
    Wait Until Page Contains Element    xpath=//div[contains(@class, 'result') or contains(., 'Cuota')]

Validar Resultados
    Element Should Be Visible    xpath=//div[contains(@class, 'result')]
    # Validar que se muestre la cuota mensual
    Element Should Be Visible    xpath=//div[contains(@class, 'result')]//*[contains(text(), 'Cuota') or contains(text(), 'cuota')]
    # Validar que el valor de la cuota sea numérico
    ${cuota}=    Get Text    xpath=//div[contains(@class, 'result')]//*[contains(text(), 'Cuota') or contains(text(), 'cuota')]/following-sibling::*[1]
    Should Match Regexp    ${cuota}    ^[\d.,]+$
    # Validar que se muestre el monto total a pagar
    Element Should Be Visible    xpath=//div[contains(@class, 'result')]//*[contains(text(), 'Total') or contains(text(), 'total')]
    # Validar que el valor del total sea numérico
    ${total}=    Get Text    xpath=//div[contains(@class, 'result')]//*[contains(text(), 'Total') or contains(text(), 'total')]/following-sibling::*[1]
    Should Match Regexp    ${total}    ^[\d.,]+$
    # Validar que se muestre la tasa de interés
    Element Should Be Visible    xpath=//div[contains(@class, 'result')]//*[contains(text(), 'Tasa') or contains(text(), 'tasa')]
    ${tasa}=    Get Text    xpath=//div[contains(@class, 'result')]//*[contains(text(), 'Tasa') or contains(text(), 'tasa')]/following-sibling::*[1]
    Should Match Regexp    ${tasa}    ^[\d.,%]+$

Validar Mensaje De Error
    Page Should Contain Element    xpath=//div[contains(@class, 'error') or contains(@class, 'error-message') or contains(@role, 'alert')]

Modificar Datos Y Volver A Simular
    Input Text    xpath=//input[@id='txtTerm']    36
    Presionar Simular

*** Test Cases ***
Simular Credito Preciso Exitosamente
    Seleccionar Tipo De Credito
    Ingresar Monto Y Plazo
    # Seleccionar Tipo De Tasa
    Presionar Simular
    Validar Resultados

Simular Credito Linea Abierta
    Set Test Variable    ${TIPO_CREDITO}    ${TIPO_CREDITO_2}
    Seleccionar Tipo De Credito
    Ingresar Monto Y Plazo
    Presionar Simular
    Validar Resultados

Simular Credito Hipotecario Vivienda
    Set Test Variable    ${TIPO_CREDITO}    ${TIPO_CREDITO_3}
    Seleccionar Tipo De Credito
    Ingresar Monto Y Plazo
    Presionar Simular
    Validar Resultados

Simular Con Campos Vacios (Negativo)
    # No ingresar monto ni plazo ni tipo de crédito
    # Asegurarse de que los campos estén vacíos
    Input Text    xpath=//input[@id='txtAmount']    ""
    Input Text    xpath=//input[@id='txtTerm']    ""
    # Intentar simular sin seleccionar tipo de crédito
    Click Button    xpath=//button[@id='btnSimulate']
    Validar Mensaje De Error

Simular Con Monto Minimo Permitido (Límite)
    Set Test Variable    ${MONTO}    1000
    Set Test Variable    ${PLAZO}    12
    Seleccionar Tipo De Credito
    Ingresar Monto Y Plazo
    Presionar Simular
    Validar Resultados

# Agrega más casos para los otros tipos si lo deseas
