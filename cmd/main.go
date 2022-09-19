package main

import (
	"fmt"

	hub "github.com/konveyor/tackle2-hub/addon"
)

var (
	// hub integration.
	addon = hub.Addon
	// HomeDir directory.
	HomeDir   = ""
	BinDir    = ""
	SourceDir = ""
	AppDir    = ""
	Dir       = ""
)

//
// main
func main() {
	addon.Run(func() (err error) {
		//
		// Get the addon data associated with the task.
		fmt.Println("Addon executed - implement me!")
		// https://github.com/konveyor/tackle2-addon-windup might be useful as an example
		return
	})
}
