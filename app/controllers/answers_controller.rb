class AnswersController < ApplicationController
  before_action :authenticate_user!,except:[:create,:new]
  def index
  end

  def show
  end

  def new
  
    @answer = Answer.new
    render :create
  end

  def create
      @question = Question.find(params[:question_id])
      @cantidad = @question.answer.where(user: current_user).count
      @ganancia=Permiso.where(nombre:"Responder",tipo:"Ganancia").first.cantidad
    if @cantidad == 0
      @answer = Answer.new(
        params.require(:answer)
          .permit(:texto,:question_id)
      )
      @answer.question_id = params[:question_id]
      @answer.user = current_user
      @answer.fecha = Time.now 
      @answer.user.votos= @answer.user.votos + @ganancia
      @answer.user.save
      if @answer.save
        redirect_to question_path(params[:question_id],:condicion => "0", :editar => "0")
      else 
        redirect_to question_path(params[:question_id],:condicion => "10", :editar => "0")
       end
    else
      redirect_to question_path(params[:question_id],:condicion => "0", :editar => "0")
    end
  end

  def edit
    
    @answer =  Answer.find(params[:id])
    
      redirect_to question_path(@answer.question.id,:condicion => "0", :editar => "1", :ida => params[:id])
   
  end

  def update
     @answer =  Answer.find(params[:id])
     @answer.update(texto: params[:answer][:texto])
     redirect_to question_path(params[:question_id],:condicion => "0", :editar => "0")
  end

  def destroy
    answer =  Answer.find(params[:id])
    if (answer.question.bestAnswer == answer.id)
      answer.question.update(bestAnswer: 0)
    end
    id = answer.question.id
    answer.destroy
    redirect_to question_path(id,:condicion => "0", :editar => "0") 
  end
end
