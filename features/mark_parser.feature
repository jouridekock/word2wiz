Feature: Getting steps from marks
    As a user
    I want to transform the marks in the word document and get the steps with
    controls
    So that I can generate a wizard configuration with the result

    Scenario: One simple control
        Given a list of marks
            | mark         |
            | one question |
          And a configuration
         When we get the steps for those marks
         Then there should be 4 steps
          And step 0 should have template "static1"
          And step 1 should have template "dynamic"
          And step 2 should have template "upload"
          And step 3 should have template "end"
          And step 1 should have 1 control
          And control 0 in step 1 should be a string control

    Scenario: Two empty steps
        Given a list of marks
            | mark |
            | step Algemeen |
          And a configuration
         When we get the steps for those marks
         Then there should be 5 steps
          And step 0 should have template "static1"
          And step 1 should have template "dynamic"
          And step 2 should have template "dynamic"
          And step 3 should have template "upload"
          And step 4 should have template "end"
          And name of step 1 should be "doc_name"
          And name of step 2 should be "Algemeen"
          And group name of step 1 should be "Buitenland"
          And group name of step 2 should be "Buitenland"

    Scenario: 2 steps with unwanted matches
        Given a list of marks
            | mark                      |
            | altijd                    |
            | question 1                |
            | step Second step          |
            | list question 2;val1;val2 |
            | altijd                    |
          And a configuration
         When we get the steps for those marks
         Then there should be 5 steps
          And step 1 should have 1 control
          And step 2 should have 1 control
          And the question for control 0 in step 1 should be "question 1"
          And the question for control 0 in step 2 should be "question 2"

    Scenario: Marks with inner spaces
        Given a list of marks
            | mark                                                |
            |  	 my mark  with	multiple 	 inner spaces         |
            | list Question  with   spaces 	; item 1	; item  2 |
          And a configuration
         When we get the steps for those marks
         Then there should be 4 step
          And step 1 should have 2 control
          And the question for control 0 in step 1 should be "my mark with multiple inner spaces"
          And the question for control 1 in step 1 should be "Question with spaces"
          And the items for control 1 in step 1 should be
              | item   |
              | item 1 |
              | item 2 |


    ############
    # Required #
    ############

    Scenario: List controls should be required by default
        Given a list of marks
            | mark                                             |
            | list Dit is de vraagtekst 1;nota;nota’s          |
            | list required Dit is de vraagtekst 2;nota;nota’s |
            | list optional Dit is de vraagtekst 3;nota;nota’s |
          And a configuration
         When we get the steps for those marks
         Then step 1 should have 3 control
          And control 0 in step 1 should be required
          And control 1 in step 1 should be required
          And control 2 in step 1 should not be required

    Scenario: String controls should be optional by default
        Given a list of marks
            | mark                            |
            | Dit is een invulveld 1          |
            | optional Dit is een invulveld 2 |
            | required Dit is een invulveld 3 |
          And a configuration
         When we get the steps for those marks
         Then step 1 should have 3 control
          And control 0 in step 1 should not be required
          And control 1 in step 1 should not be required
          And control 2 in step 1 should be required

    ##############
    # Duplicates #
    ##############

    Scenario: Duplicated string controls are removed
        Given a list of marks
            | mark                      |
            | required generic question |
            | required generic question |
            | required generic question |
            | another question |
          And a configuration
         When we get the steps for those marks
         Then step 1 should have 2 controls
          And control 0 in step 1 should be a string control
          And control 1 in step 1 should be a string control

    Scenario: Duplicated list controls are removed
        Given a list of marks
            | mark                                  |
            | list Dit is de vraagtekst;nota;nota’s |
            | list Dit is de vraagtekst;nota;nota’s |
            | list Dit is de vraagtekst;nota;nota’s |
            | list Dit is de vraagtekst;nota;nota’s2 |
          And a configuration
         When we get the steps for those marks
         Then step 1 should have 2 control
          And control 0 in step 1 should be a list control
          And control 1 in step 1 should be a list control

    Scenario: Duplicated checkboxes are not removed
        Given a list of marks
            | mark                               |
            | checkbox question;label            |
            | checkbox question;label            |
            | checkbox required question2;label2 |
            | checkbox required question2;label2 |
          And a configuration
         When we get the steps for those marks
         Then step 1 should have 4 controls
          And control 0 in step 1 should be a checkbox control
          And control 1 in step 1 should be a checkbox control
          And control 2 in step 1 should be a checkbox control
          And control 3 in step 1 should be a checkbox control

    Scenario: Duplicated lines are not removed
        Given a list of marks
            | mark |
            | line |
            | line |
            | line |
          And a configuration
         When we get the steps for those marks
         Then step 1 should have 3 controls
          And control 0 in step 1 should be a line control
          And control 1 in step 1 should be a line control
          And control 2 in step 1 should be a line control

    Scenario: Duplicated labels are not removed
        Given a list of marks
            | mark                     |
            | text Dit is gewoon tekst |
            | text Dit is gewoon tekst |
            | text Dit is gewoon tekst |
          And a configuration
         When we get the steps for those marks
         Then step 1 should have 3 controls
          And control 0 in step 1 should be a label control
          And control 1 in step 1 should be a label control
          And control 2 in step 1 should be a label control

    Scenario: Duplicated steps are not removed
        Given a list of marks
            | mark               |
            | step Repeated step |
            | step Repeated step |
            | step Repeated step |
          And a configuration
        When we get the steps for those marks
        Then there should be 7 steps
         And name of step 1 should be "doc_name"
         And name of step 2 should be "Repeated step"
         And name of step 3 should be "Repeated step"
         And name of step 4 should be "Repeated step"
         And group name of step 1 should be "Buitenland"
         And group name of step 2 should be "Buitenland"
         And group name of step 3 should be "Buitenland"
         And group name of step 4 should be "Buitenland"

    ############
    # Metadata #
    ############

    Scenario: Assigning metadatas to regular controls
        Given a list of marks
            | mark                                    |
            |   required generic question             |
            |   list Dit is de vraagtekst;nota;nota’s |
            |   line                                  | # Ignored for metadata
            |   text This is some text in a label     | # Ignored for metadata
            |   checkbox question;label               |
            | step Step2                              |
            |   text This is some text in a label     | # Ignored for metadata
            |   required generic question 2           |
            |   line                                  | # Ignored for metadata
            |   text This is some text in a label     | # Ignored for metadata
            |   list mylist;item1;item2;item3         |
            |   text This is some text in a label     | # Ignored for metadata
          And a configuration
        When we get the steps for those marks
        Then there should be 5 steps
         And step 1 should have 5 controls
         And step 2 should have 6 controls

         And control 0 in step 1 should be a string control
         And control 1 in step 1 should be a list control
         And control 2 in step 1 should be a line control
         And control 3 in step 1 should be a label control
         And control 4 in step 1 should be a checkbox control
         And control 0 in step 2 should be a label control
         And control 1 in step 2 should be a string control
         And control 2 in step 2 should be a line control
         And control 3 in step 2 should be a label control
         And control 4 in step 2 should be a list control
         And control 5 in step 2 should be a label control

         And control 0 in step 1 should have metadata "txt_001"
         And control 1 in step 1 should have metadata "txt_002"
         And control 2 in step 1 should have no metadata
         And control 3 in step 1 should have no metadata
         And control 4 in step 1 should have metadata "txt_003"
         And control 0 in step 2 should have no metadata
         And control 1 in step 2 should have metadata "txt_004"
         And control 2 in step 2 should have no metadata
         And control 3 in step 2 should have no metadata
         And control 4 in step 2 should have metadata "txt_005"
         And control 5 in step 2 should have no metadata

    ###################
    # Gekoppeldebrief #
    ###################

    Scenario: Two letters
        Given a list of marks
            | mark            |
            | step Algemeen   |
            | gekoppeldebrief |
            | step brief2     |
          And a configuration
         When we get the steps for those marks
         Then there should be 9 steps
          And step 0 should have template "static1"
          And step 1 should have template "dynamic"
          And step 2 should have template "dynamic"
          And step 3 should have template "upload"
          And step 4 should have template "static2"
          And step 5 should have template "dynamic"
          And step 6 should have template "dynamic"
          And step 7 should have template "upload"
          And step 8 should have template "end"
          And step 0 should have letter_num 1
          And step 1 should have letter_num 1
          And step 2 should have letter_num 1
          And step 3 should have letter_num 1
          And step 4 should have letter_num 2
          And step 5 should have letter_num 2
          And step 6 should have letter_num 2
          And step 7 should have letter_num 2
          And step 8 should have letter_num 2
          And name of step 1 should be "doc_name"
          And name of step 2 should be "Algemeen"
          And group name of step 1 should be "Buitenland"
          And group name of step 2 should be "Buitenland"

    Scenario: Steps should be linked
        Given a list of marks
            | mark            |
            | step Algemeen   |
            | gekoppeldebrief |
            | step brief2     |
          And a configuration
         When we get the steps for those marks
         Then next step of step 0 should be 1
          And next step of step 1 should be 2
          And next step of step 2 should be 3
          And next step of step 3 should be 4
          And next step of step 4 should be 5
          And next step of step 5 should be 6
          And next step of step 6 should be 7
          And next step of step 7 should be 8
          And step 8 should not have next step
