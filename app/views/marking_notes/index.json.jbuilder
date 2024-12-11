json.objects @marking_notes,
             partial: "marking_notes/marking_note_listing",
             as: :marking_note,
             course: @course,
             group: @group
