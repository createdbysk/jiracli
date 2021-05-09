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
	  render      Uses a golang template to render data from JIRA.
	
	Flags:
		  --config string    config file (default is $HOME/.jiracli.yaml)
	  -h, --help             help for jiracli
	
	Use "jiracli [command] --help" for more information about a command.
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

				os.Args = strings.Fields(commandline)

				captureStdout := testutils.CaptureStdout()

				expected := output

				// WHEN
				main()
				actual, err := captureStdout()

				// THEN
				if err != nil {
					t.Error(err)
				}
				if actual != expected {
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
