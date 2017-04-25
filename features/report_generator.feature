Feature: Generating a report
    As the person who will create the document in Composition Center
    I need the link between the marks in the document (questions) and the
    metadata linked to them
    So that I can create the content in Composition Center

    Scenario: One step with two controls
        Given a list of marks
            | mark             |
            | one question     |
            | another question |
        When we get the steps for those marks
         And we generate a report for those steps
        Then the report should be
            """
            +----------+------------------+----------+
            |   STEP   |      FIELD       | METADATA |
            +----------+------------------+----------+
            | doc_name | one question     | txt_001  |
            |          | another question | txt_002  |
            +----------+------------------+----------+

            """

    Scenario: Two steps with two controls
        Given a list of marks
            | mark        |
            | question 1  |
            | question 2  |
            | step step 2 |
            | question 3  |
            | question 4  |
        When we get the steps for those marks
         And we generate a report for those steps
        Then the report should be
            """
            +----------+------------+----------+
            |   STEP   |   FIELD    | METADATA |
            +----------+------------+----------+
            | doc_name | question 1 | txt_001  |
            |          | question 2 | txt_002  |
            +----------+------------+----------+
            | step 2   | question 3 | txt_003  |
            |          | question 4 | txt_004  |
            +----------+------------+----------+

            """

    Scenario: Two steps with a line
        Given a list of marks
            | mark        |
            | question 1  |
            | question 2  |
            | step step 2 |
            | question 3  |
            | question 4  |
            | line        |
            | question 5  |
            | question 6  |
        When we get the steps for those marks
         And we generate a report for those steps
        Then the report should be
            """
            +----------+------------+----------+
            |   STEP   |   FIELD    | METADATA |
            +----------+------------+----------+
            | doc_name | question 1 | txt_001  |
            |          | question 2 | txt_002  |
            +----------+------------+----------+
            | step 2   | question 3 | txt_003  |
            |          | question 4 | txt_004  |
            |          +------------+----------+
            |          | question 5 | txt_005  |
            |          | question 6 | txt_006  |
            +----------+------------+----------+

            """