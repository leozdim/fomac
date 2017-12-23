module ApplicationHelper

    def nav_project
        if current_user.projects.any?
            @proy_ready='ready'
            edit_project_path params[:id]
        else
            new_project_path
        end
    end

    def nav_participant
        if current_user.projects.any?
            if Project.find(params[:id]).people.any?
                @part_ready='ready'
                add_project_people_path params[:id]
            else
                add_project_people_path params[:id]
            end
        end
    end

    def nav_documents
        if current_user.projects.any?
            if Project.find(params[:id]).person_document.any?
                @doc_ready='ready'
                add_documents_people_path params[:id]
            elsif Project.find(params[:id]).people.any?
                add_documents_people_path params[:id]
            else
                '#'
            end
        end
    end

    def nav_anexo
        if current_user.projects.any?
            if Project.find(params[:id]).person_document.any?
                @anexo_ready='ready'
            end
            add_anexo_people_path params[:id]
        end
    end

    def nav_information
        if current_user.projects.any?
            unless Project.find(params[:id]).information.blank?
                @info_ready='ready'
            end
            project_information_path params[:id]
        end
    end

    def nav_retribution
        if current_user.projects.any?
            unless Project.find(params[:id]).retribution.blank?
                @retri_ready='ready'
            end
            project_retribution_path params[:id]
        end
    end

    #it should check the category fo the project and then return if there is any evidence, but it does not, kinda in a hurry 
    def nav_evidence
        if current_user.projects.any?
            if Project.find(params[:id]).any_evidence?
                @evi_ready='ready'
            end
            project_evidence_path params[:id]
        end
    end

end
