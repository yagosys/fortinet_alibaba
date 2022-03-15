package project

import (
	"fmt"

	"github.com/fortinet_alibaba/golang/src/sls/util"
)

func CreateProject(){
	fmt.Println("Create Project")
	fmt.Println(util.ProjectName)
	_, err := util.Client.CreateProject(util.ProjectName,"Project used for testing")
	if err != nil {
		fmt.Println(err)
	}
	project, err := util.Client.GetProject(util.ProjectName)
	if err != nil {
		panic(err)
	}
	fmt.Println("project created successfully:", project.Name)

	project, err = util.Client.UpdateProject(util.ProjectName, "Updated description")
	if err != nil{
		panic(err)
	}
	fmt.Println("Modify the description of the project successfully")
	listAllProject()
}

// List all the projects below this region.
func listAllProject() {
	offset := 0
	fmt.Println("project list: ")
	for {
		projects, count, total, err := util.Client.ListProjectV2(offset, 100)
		if err != nil {
			panic(err)
		}
		for _, project := range projects {
			fmt.Printf(" name : %s, description : %s, region : %s, ctime : %s, mtime : %s\n",
				project.Name,
				project.Description,
				project.Region,
				project.CreateTime,
				project.LastModifyTime)
		}
		if offset+count >= total {
			break
		}
		offset += count
	}
}
