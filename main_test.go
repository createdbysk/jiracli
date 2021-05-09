package main

import (
	"os"
	"strings"
	"testing"

	"github.com/createdbysk/jiracli/internal/testutils"
)

func rootHelpOutputFixture() string {
	return `jiracli is a command-line interface to JIRA.

	Usage:
	  jiracli [command]
	
	Available Commands:
	  help        Help about any command
	  render      Uses a golang template to render the data from JIRA
	
	Flags:
		  --config string   config file (default is $HOME/.jiracli.yaml)
	  -h, --help            help for jiracli
	
	Use "jiracli [command] --help" for more information about a command.
`
}

func renderHelpOutputFixture() string {
	return ` Uses a golang template to render the data from JIRA.
            
	Usage:
	  jiracli render [flags]
	
	Flags:
	  -h, --help              help for render
		  --password string   JIRA password
		  --url string        JIRA URL
		  --username string   JIRA username
	
	Global Flags:
		  --config string   config file (default is $HOME/.jiracli.yaml)
`
}

func TestCli(t *testing.T) {
	// GIVEN
	testcases := []struct {
		name        string
		commandline string
		output      string
	}{
		{
			name:        "help shorthand",
			commandline: "-h",
			output:      rootHelpOutputFixture(),
		},
		{
			name:        "render help shorthand",
			commandline: "render -h",
			output:      renderHelpOutputFixture(),
		},
	}

	for _, tt := range testcases {
		t.Run(
			tt.name,
			func(t *testing.T) {
				// GIVEN
				commandline := tt.commandline
				output := tt.output

				oldargs := os.Args
				defer func() { os.Args = oldargs }()

				os.Args = append([]string{""}, strings.Fields(commandline)...)

				captureStdout := testutils.CaptureStdout()

				expected := output

				// WHEN
				main()
				actual, err := captureStdout()

				// THEN
				if err != nil {
					t.Error(err)
				}
				if testutils.RemoveWhitespace(actual) != testutils.RemoveWhitespace(expected) {
					t.Errorf(
						"Test command-line\n Expected output\n %s \n\n Actual output\n %s\n",
						expected,
						actual,
					)
				}
			},
		)
	}
}
