class StudentsController < ApplicationController
  NEEDED_ATTRIBUTES = %w[id first_name last_name surname]

  def index
    class_id = params[:class_id]
    school_id = params[:school_id]

    students = Student.includes(:school_class)
                      .where(class_id: class_id,
                             school_class: { school_id: school_id })

    students = students.map do |student|
      student.attributes.slice(*NEEDED_ATTRIBUTES)
             .merge({ class_id: class_id, school_id: school_id })
    end

    render json: { data: students }, status: 200
  end

  def create
    school_id = params[:student][:school_id]
    @student = Student.new(student_params)

    if student_saved_and_valid_school?(school_id)
      render_student_with_token
    else
      render_invalid_input_error
    end
  end

  def destroy
    @student = Student.find(params[:id])
    token = request.headers["Authorization"].split(" ").last

    unauthorized unless @student.valid_token?(token)

    destroy_student
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Студент не найден" }, status: :not_found
  end

  private

  def student_params
    params.require(:student).permit(:first_name, :last_name, :surname, :class_id)
  end

  def school_id_valid?(school_id)
    (school_id == @student.school_class.school.id)
  end

  def student_saved_and_valid_school?(school_id)
    @student.save && school_id_valid?(school_id)
  end

  def unauthorized
    render json: { error: "Некорректная авторизация" }, status: :unauthorized
  end

  def render_student_with_token
    token = @student.generate_token
    response.headers['X-Auth-Token'] = token

    @student = @student.attributes.slice(*NEEDED_ATTRIBUTES)
                       .merge({ class_id: params[:student][:class_id],
                                school_id: params[:student][:school_id] })

    render json: @student, status: :created, headers: { 'X-Auth-Token': token }
  end

  def render_invalid_input_error
    render json: { error: 'Invalid input' }, status: 405
  end

  def destroy_student
    if @student.destroy
      head :no_content
    else
      render json: { error: "Невозможно удалить студента" }, status: 400
    end
  end
end
