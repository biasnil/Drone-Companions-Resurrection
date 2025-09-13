module DCO.Robots
import Codeware.*

public class DCO_RobotSystem extends ScriptableSystem {
  private let m_entitySystem: wref<DynamicEntitySystem>;
  private let m_cb: wref<CallbackSystem>;
  private let m_ready: Bool;

  protected func OnAttach() -> Void {
    this.m_entitySystem = GameInstance.GetDynamicEntitySystem();
    this.m_cb = GameInstance.GetCallbackSystem();
    this.m_cb.RegisterCallback(n"Session/Ready", this, n"OnReady");
    this.m_cb.RegisterCallback(n"DCO.Robots.SpawnRequest", this, n"OnSpawn");
  }

  private cb func OnReady(e: ref<GameSessionEvent>) {
    this.m_ready = true;
  }

  private cb func OnSpawn(e: ref<SpawnRequest>) {
    this.EnsureBot(e.GetRecord(), e.GetSlot());
  }

  public func EnsureBot(recordID: TweakDBID, slot: CName) -> EntityID {
    let spec = new DynamicEntitySpec();
    spec.recordID = recordID;
    spec.persistState = true;
    spec.persistSpawn = true;
    spec.tags = [n"DCO.Bot", slot];
    spec.active = true;
    return this.m_entitySystem.CreateEntity(spec);
  }
}

public class SpawnRequest extends CallbackSystemEvent {
  private let record: TweakDBID;
  private let slot: CName;

  public func GetRecord() -> TweakDBID = this.record;
  public func GetSlot() -> CName = this.slot;

  public func Init(record: TweakDBID, slot: CName) -> Void {
    this.record = record;
    this.slot = slot;
  }
}
