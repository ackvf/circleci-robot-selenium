*** Settings ***
# Suite Setup         Open Browser To    ${LANDING PAGE}
Suite Teardown      Close Browser
Resource            resource.robot

*** Variables ***
${LANDING PAGE}     http://qry.me/template.html

*** Test Cases ***
Page Has Loaded
    Open Browser     ${LANDING PAGE}    ${BROWSER}
    Maximize Browser Window
    Element Should Be Visible    center