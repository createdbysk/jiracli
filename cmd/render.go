/*
Copyright © 2021 Satish Kumar

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
package cmd

import (
	"errors"
	"fmt"
	"log"

	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

// renderCmd represents the render command
var renderCmd = &cobra.Command{
	Use:   "render",
	Short: "Uses a golang template to render the data from JIRA",
	Long:  `Uses a golang template to render the data from JIRA.`,
	Args: func(cmd *cobra.Command, args []string) error {
		if len(args) < 2 {
			return errors.New("you must provide the path to the template file and the jql for the JIRA query to extract the data")
		}
		url := viper.Get("url")
		log.Printf("URL = %s", url)
		if url == "" {
			return errors.New("required flag 'url' not set")
		}
		return nil
	},
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("render called")
	},
}

func init() {
	rootCmd.AddCommand(renderCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// renderCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	renderCmd.Flags().StringP("url", "", "", "JIRA URL")
	renderCmd.Flags().StringP("username", "", "", "JIRA username")
	renderCmd.Flags().StringP("password", "", "", "JIRA password")

	viper.AutomaticEnv()
	viper.SetEnvPrefix("JIRA")
	viper.BindEnv("url")
}
