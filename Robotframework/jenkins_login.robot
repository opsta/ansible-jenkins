*** Settings ***
Library         SeleniumLibrary     
*** Variables ***
${URL}                      http://localhost:8080
${BROWSER}                  headlesschrome

${input_USERNAME}           //*[@id="j_username"]
${input_PASSWORD}           //*[@name="j_password"]

${USERNAME}                 admin
${PASSWORD}                 password

${Sige_in_button}           //*[@value="Sign in"]
*** Keywords ***
open
    Open Browser            ${URL}  ${BROWSER}
Input username and password
    Input Text              ${input_USERNAME}   ${USERNAME} 
    Input Password          ${input_PASSWORD}   ${PASSWORD}   
    Capture Page Screenshot
    Click Element           ${Sige_in_button}
    Capture Page Screenshot    
*** Test Cases ***
start
    open
login
    ${html}                             Get Source
    Log                                 ${html}  
    Input username and password